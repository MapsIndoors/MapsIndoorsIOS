//
//  MPDirectionsQuery.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 26/01/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPLocation.h"


@class MPUserRole;


typedef NS_ENUM(NSUInteger, MPTravelMode) {
    MPTravelModeUnknown,
    MPTravelModeWalking,
    MPTravelModeBicycling,
    MPTravelModeDriving,
    MPTravelModeTransit,
};

/**
 Directions query model.
 */
@interface MPDirectionsQuery : NSObject

+ (nonnull instancetype)new NS_UNAVAILABLE;
-(nonnull instancetype) __unavailable init;

/**
 Initialiser that takes locations as origin and destination.

 @param origin Origin location.
 @param destination Destination location.
 @return The directions query instance.
 */
-(nonnull instancetype) initWithOrigin:(nonnull MPLocation*)origin destination:(nonnull MPLocation*)destination;
/**
 Initialiser that takes points as origin and destination.
 
 @param origin Origin point.
 @param destination Destination point.
 @return The directions query instance.
 */
-(nonnull instancetype) initWithOriginPoint:(nonnull MPPoint*)origin destination:(nonnull MPPoint*)destination;

/**
 Way types that should be avoided when calculating routes. Currently supports `"stairs"`.
 */
@property (nonatomic, strong, nullable) NSArray<NSString*>* avoidWayTypes;
/**
 Origin location.
 */
@property (nonatomic, strong, nonnull) MPLocation* origin;
/**
 Detination location.
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

/**
 The user roles that the route should match.
 */
@property (nonatomic, strong, nullable) NSArray<MPUserRole*>*       userRoles;

@end

