//
//  MPDirectionsQuery.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 26/01/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPLocation.h"
#import "MPDefines.h"


@class MPUserRole;


typedef NS_ENUM(NSUInteger, MPTravelMode) {
    MPTravelModeUnknown,
    MPTravelModeWalking,
    MPTravelModeBicycling,
    MPTravelModeDriving,
    MPTravelModeTransit,
};

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Directions query model.
 */
@interface MPDirectionsQuery : NSObject

+ (nonnull instancetype)new NS_UNAVAILABLE;
-(nonnull instancetype) __unavailable init;

/**
 Initialiser that takes locations as origin and destination.

 - Parameter origin: Origin location.
 - Parameter destination: Destination location.
 - Returns: The directions query instance.
 */
-(nonnull instancetype) initWithOrigin:(nonnull MPLocation*)origin destination:(nonnull MPLocation*)destination;
/**
 Initialiser that takes points as origin and destination.
 
 - Parameter origin: Origin point.
 - Parameter destination: Destination point.
 - Returns: The directions query instance.
 */
-(nonnull instancetype) initWithOriginPoint:(nonnull MPPoint*)origin destinationPoint:(nonnull MPPoint*)destination;

/**
 Way types that should be avoided when calculating routes. Supports any `MPHighwayType`.
 */
@property (nonatomic, strong, nullable) NSArray<MPHighwayType>* avoidWayTypes;
/**
 Origin location.
 */
@property (nonatomic, strong, nonnull) MPLocation* origin;
/**
 Destination location.
 */
@property (nonatomic, strong, nonnull) MPLocation* destination;
/**
 Date for arrival. Setting both arrival and departure will result in undefined behavior.
 */
@property (nonatomic, strong, nullable) NSDate* arrival;
/**
 Date for departure. Setting both arrival and departure will result in undefined behavior.
 */
@property (nonatomic, strong, nullable) NSDate* departure;
/**
 Set travel mode. Default is walking.
 */
@property (nonatomic) MPTravelMode travelMode;

@end

