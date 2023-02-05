//
//  MPPoint.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 7/29/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import <CoreLocation/CoreLocation.h>

#import "MPGeometry.h"

@protocol MPPoint
@end

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Basic point geometry class.
 */

@interface MPPoint : MPGeometry

/**
 Regular geographic point geometry initialization.
 */
- (_Nonnull instancetype)initWithLat:(double)latitude lon:(double)longitude;
/**
 Indoor geographic point geometry initialization.
 */
- (_Nonnull instancetype)initWithLat:(double)latitude lon:(double)longitude zValue:(double)z;
/**
 Get the latitude component.
 */
- (double)lat;
/**
 Get the longitude component.
 */
- (double)lng;
/**
 Get the z / floorIndex component.
 */
- (double)z;
/**
 Get the z / floorIndex component as a rounded index.
 */
- (int)zIndex;
/**
 Set the z / floorIndex component.
 */
- (void)setZValue:(double)z;
/**
 Calculate the 2d geographic distance to another point.
 */
- (double)distanceTo:(nonnull MPPoint*)point;

/**
 Get latitude/logitude value as a string

 @return Latitude/logitude as comma separated string
 */
- (nonnull NSString *)latLngString;

/**
 Static MPPoint builder. Parses a comma separated string an returns an MPPoint instance.

 @param coordinate Latitude, longitude, floor as a comma separated string
 @return The resulting MPPoint instance
 */
+ (nullable MPPoint*)parse: (nonnull NSString*) coordinate;

/**
 Get a CoreLocation coordinate struct representation of the MPPoint

 @return A 2d coordinate struct
 */
- (CLLocationCoordinate2D)getCoordinate;

@end
