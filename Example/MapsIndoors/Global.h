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

#import <Foundation/Foundation.h>
#import <MapsIndoors/MapsIndoors.h>
#import "POIData.h"
#import "RoutingData.h"


@interface Global : NSObject

+ (NSString*) solutionId;
+ (void) setSolutionId:(NSString*)value;

+ (MPSolution*) solution;
+ (void) setSolution:(MPSolution*)value;

+ (MPVenue*) venue;
+ (void) setVenue:(MPVenue*)value;

+ (MPPoint*) initialPosition;
+ (void) setInitialPosition:(MPPoint*)value;

+ (POIData*) poiData;
+ (void) setPoiData:(POIData*)value;

+ (RoutingData*) routingData;
+ (void) setRoutingData:(RoutingData*)value;

+ (NSArray*) appColors;
+ (void) setAppColors:(NSArray*)value;

+ (id<MPPositionProvider>) positionProvider;

+ (void) setupPositioning;

+ (NSString*)getIconUrlForType: (NSString*)typeName;

+ (MPLocationDisplayRule*)getDisplayRuleForType:(NSString*) typeName;

+ (NSString*) getAddressForLocation: (MPLocation*) location;


@end
