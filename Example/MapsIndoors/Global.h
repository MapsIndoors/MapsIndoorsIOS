//
//  Global.h
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 02/09/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

//Directions rendering
#define kDashSize 4;
#define kLineWidth 4;
//Strings
#define kYouAreHere @"You are here"

#import <Foundation/Foundation.h>
#import <MapsIndoorsSDK/MapsIndoorsSDK.h>
#import "POIData.h"
#import "RoutingData.h"


@interface Global : NSObject

+ (NSString*) solutionId;
+ (void) setSolutionId:(NSString*)value;

+ (MPSolution*) solution;
+ (void) setSolution:(MPSolution*)value;

+ (NSString*) venue;
+ (void) setVenue:(NSString*)value;

+ (MPPoint*) initialPosition;
+ (void) setInitialPosition:(MPPoint*)value;

+ (POIData*) poiData;
+ (void) setPoiData:(POIData*)value;

+ (RoutingData*) routingData;
+ (void) setRoutingData:(RoutingData*)value;

+ (id<MPPositionProvider>) positionProvider;

+ (void) setupPositioning;

+ (NSString*)getIconUrlForType: (NSString*)typeName;

@end
