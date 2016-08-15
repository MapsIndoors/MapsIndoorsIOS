//
//  Global.m
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 02/09/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import "Global.h"
#import <MapsIndoorsSDK/MapsIndoorsSDK.h>

#import "GPSPositionProvider.h"
#import "BeaconPositionProvider.h"

@implementation Global

static NSString* solutionId;
+ (NSString*) solutionId
{ @synchronized(self) { return solutionId; } }
+ (void) setSolutionId:(NSString*)value
{ @synchronized(self) { solutionId = value; } }

static MPSolution* solution;
+ (MPSolution*) solution
{ @synchronized(self) { return solution; } }
+ (void) setSolution:(MPSolution*)value
{ @synchronized(self) { solution = value; } }

static MPVenue* venue;
+ (MPVenue*) venue
{ @synchronized(self) { return venue; } }
+ (void) setVenue:(MPVenue*)value
{ @synchronized(self) { venue = value; } }

static MPPoint* initialPosition;
+ (MPPoint*) initialPosition
{ @synchronized(self) { return initialPosition; } }
+ (void) setInitialPosition:(MPPoint*)value
{ @synchronized(self) { initialPosition = value; } }

static POIData* poiData;
+ (POIData*) poiData
{ @synchronized(self) { return poiData; } }
+ (void) setPoiData:(POIData*)value
{ @synchronized(self) { poiData = value; } }

static RoutingData* routingData;
+ (RoutingData*) routingData
{ @synchronized(self) { return routingData; } }
+ (void) setRoutingData:(RoutingData*)value
{ @synchronized(self) { routingData = value; } }

static NSArray* appColors;
+ (NSArray*) appColors
{ @synchronized(self) { return appColors; } }
+ (void) setAppColors:(NSArray*)value
{ @synchronized(self) { appColors = value; } }

static id<MPPositionProvider> positionProvider;
+ (id<MPPositionProvider>) positionProvider
{ @synchronized(self) { return positionProvider; } }

+ (void) setupPositioning {
    positionProvider = [[GPSPositionProvider alloc] init];
    [positionProvider startPositioning:nil];
    //positionProvider = [[MFPPositionProvider alloc] init];
    //[positionProvider startPositioning:nil];
    //positionProvider = [[BeaconPositionProvider alloc] initWithUUID:@"f7826da6-4fa2-4e98-8024-bc5b71e0893e"];
    //[positionProvider startPositioning:Global.solutionId];
}

+ (NSString*)getIconUrlForType:(NSString*) typeName {
    if (Global.solution) {
        for (MPType* type in Global.solution.types) {
            if ([type.name isEqualToString:typeName]) {
                return type.icon;
            }
        }
    }
    return @"";
}

+ (MPLocationDisplayRule*)getDisplayRuleForType:(NSString*) typeName {
    if (Global.solution) {
        for (MPType* type in Global.solution.types) {
            if ([type.name isEqualToString:typeName]) {
                return type.displayRule;
            }
        }
    }
    return nil;
}


+ (NSString*) getAddressForLocation: (MPLocation*) location {
    MPLocationDisplayRule* displayRule = location.displayRule;
    if (displayRule == nil) displayRule = [Global getDisplayRuleForType:location.type];
    NSString* addr = location.name;
    if (displayRule) {
        addr = [displayRule getLabelContent:location];
    }
//    if (location.building) {
//        if (location.building.length > 3) {
//            addr = [addr stringByAppendingFormat:@" in %@", location.building];
//        } else {
//            addr = [addr stringByAppendingFormat:@" in building %@", location.building];
//        }
//    }
//    if (location.venue) {
//        addr = [addr stringByAppendingFormat:@" at %@", location.venue];
//    }
    return addr;
}

@end
