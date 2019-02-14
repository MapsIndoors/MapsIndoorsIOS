//
//  MPRouteLeg.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 12/2/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import "MPJSONModel.h"
#import "MPLineGeometry.h"
#import "MPRouteCoordinate.h"
#import "MPRouteProperty.h"
#import "MPRouteStep.h"


typedef NS_ENUM(NSUInteger, MPRouteLegType) {
    MPRouteLegTypeMapsIndoors,
    MPRouteLegTypeGoogle
};


/**
 Route leg model. A route model will consist of one ore more route legs. Typically a route from 1st floor to 2nd floor will consist of two route legs. Thus, a route leg defines a continueus route part within the same floor and/or building and/or vehicle.
 */
@interface MPRouteLeg : MPJSONModel

/**
 The route leg distance in meters
 */
@property (nonatomic, strong, nullable) NSNumber<Optional>* distance;

/**
 The route leg duration in seconds
 */
@property (nonatomic, strong, nullable) NSNumber<Optional>* duration;
/**
 The route leg start position
 */
@property (nonatomic, strong, nullable) MPRouteCoordinate<Optional>* start_location;
/**
 The route leg end position
 */
@property (nonatomic, strong, nullable) MPRouteCoordinate<Optional>* end_location;
/**
 The route leg start address. If the position is outdoors, the address may be a postal address. If the position is indoors, the address may be a textual description of the indoor location, like "Lower Ground Floor, Building X".
 */
@property (nonatomic, strong, nullable) NSString<Optional>* start_address;
/**
 The route leg end address. If the position is outdoors, the address may be a postal address. If the position is indoors, the address may be a textual description of the indoor location, like "Lower Ground Floor, Building X".
 */
@property (nonatomic, strong, nullable) NSString<Optional>* end_address;
/**
 Collection of steps for the route leg.
 */
@property (nonatomic, strong, nullable) NSMutableArray<MPRouteStep*><MPRouteStep, Optional>* steps;
/**
 The type of leg, determined by the source service, Google or MapsIndoors.
 */
@property (nonatomic) MPRouteLegType        routeLegType;

@end
