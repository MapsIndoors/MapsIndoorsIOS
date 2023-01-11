//
//  MPRouteLeg.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 12/2/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"
#import "MPLineGeometry.h"
#import "MPRouteCoordinate.h"
#import "MPRouteProperty.h"
#import "MPRouteStep.h"


typedef NS_ENUM(NSUInteger, MPRouteLegType) {
    MPRouteLegTypeMapsIndoors,
    MPRouteLegTypeGoogle
};

NS_ASSUME_NONNULL_BEGIN

/**
 Route leg model. A route model will consist of one ore more route legs. Typically a route from 1st floor to 2nd floor will consist of two route legs. Thus, a route leg defines a continueus route part within the same floor and/or building and/or vehicle.
 */
@interface MPRouteLeg : JSONModel

/**
 The route leg distance in meters
 */
@property (nonatomic, strong, readonly) NSNumber* distance;

/**
 The route leg duration in seconds
 */
@property (nonatomic, strong, readonly) NSNumber* duration;
/**
 The route leg start position
 */
@property (nonatomic, strong, readonly) MPRouteCoordinate* start_location;
/**
 The route leg end position
 */
@property (nonatomic, strong, readonly) MPRouteCoordinate* end_location;
/**
 The route leg start address. If the position is outdoors, the address may be a postal address. If the position is indoors, the address may be a textual description of the indoor location, like "Lower Ground Floor, Building X".
 */
@property (nonatomic, strong, readonly) NSString* start_address;
/**
 The route leg end address. If the position is outdoors, the address may be a postal address. If the position is indoors, the address may be a textual description of the indoor location, like "Lower Ground Floor, Building X".
 */
@property (nonatomic, strong, readonly) NSString* end_address;
/**
 Collection of steps for the route leg.
 */
@property (nonatomic, strong, readonly) NSArray<MPRouteStep*>* steps;
/**
 The type of leg, determined by the source service, Google or MapsIndoors.
 */
@property (nonatomic, readonly) MPRouteLegType        routeLegType;

@end

NS_ASSUME_NONNULL_END
