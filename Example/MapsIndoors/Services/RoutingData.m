//
//  RoutingData.m
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 02/09/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import "RoutingData.h"
#import "LocalizedStrings.h"
#import "Global.h"
@import HashBuilder;
@import MaterialControls;

@implementation RoutingData {
    MPDirectionsService* _service;
    MDSnackbar* _bar;
    MPVenueProvider* _venueProvider;
}

- (void)routingFrom:(MPLocation *)from to:(MPLocation *)to by:(NSString *)mode avoid:(NSArray *)restrictions depart:(NSDate *)departureTime arrive:(NSDate *)arrivalTime {
    
    _venueProvider = [[MPVenueProvider alloc] init];
    
    _service = [[MPDirectionsService alloc] initWithMapsIndoorsSolutionId:self.solutionId googleApiKey:self.googleApiKey];
    _service.delegate = self;
    
    self.origin = from;
    self.destination = to;
    
    HashBuilder *builder = [HashBuilder builder];
    
    [builder contributeObject:[[from getPoint] description]];
    [builder contributeObject:[[to getPoint] description]];
    [builder contributeObject:mode];
    [builder contributeObject:[restrictions componentsJoinedByString:@","]];
    
    self.destination = to;
    self.origin = from;
    [_service routingFrom:from to:to by:mode avoid:restrictions depart:departureTime arrive:arrivalTime completionHandler:^(MPRoute *route, NSError *error) {
        if (error && !_bar.isShowing) {
            _bar = [[MDSnackbar alloc] initWithText:kLangCouldNotFindDirections actionTitle:@"" duration:4.0];
            [_bar show];
        }
    }];
    
    /*if (builder.builtHash != self.latestRoutingRequestHash) {
        //self.latestRoute = nil;
        self.destination = to;
        self.origin = from;
        [_service routingFrom:from to:to by:mode avoid:restrictions depart:departureTime arrive:arrivalTime];
        self.latestRoutingRequestHash = builder.builtHash;
    } else if (self.latestRoute) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RoutingDataReady" object: self.latestRoute];
    }*/
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RoutingRequestStarted" object: self.latestRoute];

}

- (void)onRouteResultReady:(MPRoute *)route {
    self.latestRoute = route;
    __block int missingAddresses = 0;
    for (int i = 0; i < self.latestRoute.legs.count; i++) {
        MPRouteLeg* leg = [self.latestRoute.legs objectAtIndex:i];
        MPRouteStep* firstStep = leg.steps.firstObject;
        MPRouteStep* lastStep = leg.steps.lastObject;
        if (leg.start_address == nil && i > 0) {
            
            missingAddresses++;
            
            MPMapExtend* extend = [[MPMapExtend alloc] init];
            extend.north = [firstStep.start_location.lat doubleValue] - 0.001;
            extend.south = [firstStep.start_location.lat doubleValue] + 0.001;
            extend.west = [firstStep.start_location.lng doubleValue] - 0.001;
            extend.east = [firstStep.start_location.lng doubleValue] + 0.001;
            
            ^void(MPRouteLeg* currentLeg){
                
                [_venueProvider getBuildingWithinBoundsAsync:extend arg:Global.solutionId language:LocalizationGetLanguage completionHandler:^(MPBuilding *building, NSError *error) {
                    if (error == nil) {
                        MPRouteStep* firstStep = currentLeg.steps.firstObject;
                        MPFloor* startFloor = [building.floors objectForKey:[firstStep.end_location.zLevel stringValue]];
                        currentLeg.start_address = [NSString stringWithFormat:kLangLevel_var, startFloor.name];
                        
                        if (--missingAddresses == 0) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"RoutingDataReady" object: self.latestRoute];
                        }
                    }
                }];
                
                
            }(leg);
            
        }
        else if (leg.end_address == nil && i < self.latestRoute.legs.count - 1) {
            
            missingAddresses++;
            
            MPMapExtend* extend = [[MPMapExtend alloc] init];
            extend.north = [lastStep.end_location.lat doubleValue] - 0.001;
            extend.south = [lastStep.end_location.lat doubleValue] + 0.001;
            extend.west = [lastStep.end_location.lng doubleValue] - 0.001;
            extend.east = [lastStep.end_location.lng doubleValue] + 0.001;
            
            ^void(MPRouteLeg* currentLeg){
                
                [_venueProvider getBuildingWithinBoundsAsync:extend arg:Global.solutionId language:LocalizationGetLanguage completionHandler:^(MPBuilding *building, NSError *error) {
                    if (error == nil) {
                        MPRouteStep* lastStep = currentLeg.steps.lastObject;
                        MPFloor* endFloor = [building.floors objectForKey:[lastStep.end_location.zLevel stringValue]];
                        currentLeg.end_address = [NSString stringWithFormat:kLangLevel_var, endFloor.name];
                        
                        if (--missingAddresses == 0) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"RoutingDataReady" object: self.latestRoute];
                        }
                    }
                }];
                
            }(leg);
            
        }

    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RoutingDataReady" object: self.latestRoute];
}


@end
