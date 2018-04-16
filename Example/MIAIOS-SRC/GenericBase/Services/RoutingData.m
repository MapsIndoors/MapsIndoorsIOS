//
//  RoutingData.m
//  MIAIOS
//
//  Created by Daniel Nielsen on 02/09/15.
//  Copyright (c) 2015-2018 MapsPeople A/S. All rights reserved.
//

#import "RoutingData.h"
#import "LocalizedStrings.h"
#import "Global.h"
@import HashBuilder;
@import MaterialControls;
#import "NSString+TRAVEL_MODE.h"
#import <MapsIndoors/MapsIndoors.h>

#if DEBUG && 0
    #define DEBUGLOG(fMT,...)  NSLog( @"[D] RoutingData.m(%d): "fMT,  __LINE__, __VA_ARGS__ )
#else
    #define DEBUGLOG(fMt,...)  /* Nada! */
#endif


@interface RoutingData ()

@property (nonatomic, strong) MPDirectionsService*  service;
@property (nonatomic, strong) MDSnackbar*           bar;
@property (nonatomic, strong) MPVenueProvider*      venueProvider;
    
@end


@implementation RoutingData

- (void)routingFrom:(MPLocation *)from to:(MPLocation *)to by:(NSString *)mode avoid:(NSArray *)restrictions depart:(NSDate *)departureTime arrive:(NSDate *)arrivalTime {
    
    self.travelMode = mode;
    self.service = [MPDirectionsService new];
    self.origin = from;
    self.destination = to;
    
    HashBuilder *builder = [HashBuilder builder];
    [builder contributeObject:[[from getPoint] description]];
    [builder contributeObject:[[to getPoint] description]];
    [builder contributeObject:mode];
    [builder contributeObject:[restrictions componentsJoinedByString:@","]];
    for ( NSString* s in restrictions ) {
        [builder contributeObject:s];
    }
    
    if ( builder.builtHash != self.latestRoutingRequestHash ) {
        
        MPDirectionsService*  s = self.service;
        
        DEBUGLOG( @"REQUEST  routingFrom: %@ -> %@ using %@ => %@ (hash %@)", from.name, to.name, mode, s == self.service ? @"Latest" : @"OBSOLETE", @(builder.builtHash) );

        MPDirectionsQuery*  q = [[MPDirectionsQuery alloc] initWithOrigin:from destination:to];
        q.avoidWayTypes = restrictions;
        q.departure = departureTime;
        q.arrival = arrivalTime;
        q.travelMode = [mode as_MPTravelMode];

        [s routingWithQuery:q completionHandler:^(MPRoute *route, NSError *error) {

            DEBUGLOG( @"RESPONSE routingFrom: %@ -> %@ using %@ => %@ (hash %@)", from.name, to.name, mode, s == self.service ? @"Latest" : @"OBSOLETE", @(builder.builtHash) );
            
            if ( route && !error ) {
                [self removeTransitWaitingSteps:route];
            }
            
            if ( s == self.service ) {      // Is this the latest started request ?

                dispatch_async(dispatch_get_main_queue(), ^(void) {
                    if (error) {
                        if ( !_bar.isShowing ) {
                            _bar = [[MDSnackbar alloc] initWithText:kLangCouldNotFindDirections actionTitle:@"" duration:2.0];
                            [_bar show];
                        }
                        self.latestRoutingRequestHash = 0;
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"RoutingDataReady" object: nil];
                    } else {
                        self.latestRoutingRequestHash = builder.builtHash;
                        self.latestRoute = route;
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"RoutingDataReady" object: self.latestRoute];
                    }
                });
            }
        }];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RoutingRequestStarted" object: self.latestRoute];
        
    } else if ( self.latestRoute ) {

        DEBUGLOG( @"CACHE    routingFrom: Using cached route result with hash %@", @(builder.builtHash) );
        
        self.service = nil;     // Invalidate pending route request (if any)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RoutingDataReady" object: self.latestRoute];
    }
}

- (void) removeTransitWaitingSteps:(MPRoute*)route {
    
    for ( MPRouteLeg* leg in route.legs ) {
        if ( (leg.routeLegType == MPRouteLegTypeGoogle) && (leg.steps.count > 2) ) {
            
            NSMutableIndexSet*  indexesToRemove = [NSMutableIndexSet indexSet];
            
            for ( int ix = 0; ix < (leg.steps.count -2); ++ix ) {
                MPRouteStep*    thisStep = leg.steps[ix];
                TRAVEL_MODE     thisTravelMode = [thisStep.travel_mode as_TRAVEL_MODE];
                MPRouteStep*    nextStep = leg.steps[ix+1];
                TRAVEL_MODE     nextTravelMode = [nextStep.travel_mode as_TRAVEL_MODE];
                MPRouteStep*    nextNextStep = leg.steps[ix+2];
                TRAVEL_MODE     nextNextTravelMode = [nextNextStep.travel_mode as_TRAVEL_MODE];
                NSUInteger      nextStepDistance = [nextStep.distance unsignedIntegerValue];

                //
                // Detect TRANSIT -> WALK (0m) -> TRANSIT:
                //
                // It is used by Google to signify a switch of vehicle: ex. arriving with one bus, wait at the spot, depart with another bus later.
                // Google routing directions also "collapse" this sequence, and shows the arrival and departure times at the switch point;
                // the 0-length walking step is *not* shown explicitly.
                //
                // Currently our UI does not handle arrival/departure times, and the step is removed from the route for now.
                //
                if ( (thisTravelMode == TRANSIT) && (nextTravelMode == WALK) && (nextNextTravelMode == TRANSIT) && (nextStepDistance == 0) ) {

                    NSString*   arrivalStopName = thisStep.transit_details.arrival_stop.name;
                    NSString*   departureStopName = nextNextStep.transit_details.departure_stop.name;
                    
                    if ( arrivalStopName && [arrivalStopName isEqualToString:departureStopName] ) {
                        [indexesToRemove addIndex:ix+1];
                        ++ix;   // No need to consider the walking step in next loop iteration.
                    }
                }
            }
            
            if ( indexesToRemove.count ) {
                [leg.steps removeObjectsAtIndexes:indexesToRemove];
            }
        }
    }
}

@end
