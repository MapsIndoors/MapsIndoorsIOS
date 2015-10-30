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

static NSString* venue;
+ (NSString*) venue
{ @synchronized(self) { return venue; } }
+ (void) setVenue:(NSString*)value
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

static id<MPPositionProvider> positionProvider;
+ (id<MPPositionProvider>) positionProvider
{ @synchronized(self) { return positionProvider; } }

+ (void) setupPositioning {
    positionProvider = [[GPSPositionProvider alloc] init];
    [positionProvider startPositioning:nil];
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

@end
