//
//  MPDirectionsQuery.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 26/01/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPLocation.h"

typedef NS_ENUM(NSUInteger, MPTravelMode) {
    MPTravelModeUnknown,
    MPTravelModeWalking,
    MPTravelModeBicycling,
    MPTravelModeDriving,
    MPTravelModeTransit,
};

@interface MPDirectionsQuery : NSObject

+ (nonnull instancetype)new NS_UNAVAILABLE;
-(nonnull instancetype) __unavailable init;
-(nonnull instancetype) initWithOrigin:(nonnull MPLocation*)origin destination:(nonnull MPLocation*)destination;
-(nonnull instancetype) initWithOriginPoint:(nonnull MPPoint*)origin destination:(nonnull MPPoint*)destination;

@property (nonatomic, strong, nullable) NSArray<NSString*>* avoidWayTypes;
@property (nonatomic, strong, nonnull) MPLocation* origin;
@property (nonatomic, strong, nonnull) MPLocation* destination;
@property (nonatomic, strong, nullable) NSDate* arrival;
@property (nonatomic, strong, nullable) NSDate* departure;
@property (nonatomic) MPTravelMode travelMode;

@end

