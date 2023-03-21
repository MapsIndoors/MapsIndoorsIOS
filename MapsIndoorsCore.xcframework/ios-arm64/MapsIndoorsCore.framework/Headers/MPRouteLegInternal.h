//
//  MPRouteLegInternal.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 12/2/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"
#import "MPRouteStepInternal.h"

@protocol MPRouteStepInternal;;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Route leg model. A route model will consist of one ore more route legs. Typically a route from 1st floor to 2nd floor will consist of two route legs. Thus, a route leg defines a continueus route part within the same floor and/or building and/or vehicle.
 */
@interface MPRouteLegInternal : JSONModel<MPRouteLeg>

/**
 The route leg distance in meters
 */
@property (nonatomic, strong) NSNumber* distance;

/**
 The route leg duration in seconds
 */
@property (nonatomic, strong) NSNumber* duration;
/**
 The route leg start position
 */
@property (nonatomic, strong) MPRouteCoordinateInternal* start_location;
/**
 The route leg end position
 */
@property (nonatomic, strong) MPRouteCoordinateInternal* end_location;
/**
 The route leg start address. If the position is outdoors, the address may be a postal address. If the position is indoors, the address may be a textual description of the indoor location, like "Lower Ground Floor, Building X".
 */
@property (nonatomic, copy) NSString* start_address;
/**
 The route leg end address. If the position is outdoors, the address may be a postal address. If the position is indoors, the address may be a textual description of the indoor location, like "Lower Ground Floor, Building X".
 */
@property (nonatomic, copy) NSString* end_address;
/**
 Collection of steps for the route leg.
 */
@property (nonatomic, copy) NSArray<id<MPRouteStep>><MPRouteStepInternal>* steps;
/**
 The type of leg, determined by the source service, Google or MapsIndoors.
 */
@property (nonatomic) MPRouteLegType        routeLegType;

// Moved from MPRouteLeg+Mutable
@property (nonatomic, strong, nullable) NSMutableArray<id<MPRouteStep>><MPRouteStepInternal>* mutableSteps;

- (void)addStep:(nonnull id<MPRouteStep>)step;

@end

NS_ASSUME_NONNULL_END
