//
//  MPPoint.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 7/29/13.
//  Copyright (c) 2013 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
@import JSONModel;

#import "MPGeometry.h"

@protocol MPPoint
@end

/**
 * Basic point geometry class.
 */

@interface MPPoint : MPGeometry

/**
 * 2d point geometry initialization.
 */
- initWithLat:(double)latitude lon:(double)longitude;
/**
 * 3d point geometry initialization.
 */
- initWithLat:(double)latitude lon:(double)longitude zValue:(double)z;
/**
 * Get the latitude component.
 */
- (double)lat;
/**
 * Get the longitude component.
 */
- (double)lng;
/**
 * Get the z / altitude component.
 */
- (double)z;
/**
 * Get the z component as a rounded index.
 */
- (int)zIndex;
/**
 * Set the z / altitude component.
 */
- (void)setZValue:(double)z;
/**
 * Calculate the 2d geo distance to another point.
 */
- (double)distanceTo:(MPPoint*)point;
- (NSString *)latLngString;
+ (MPPoint*)parse: (NSString*) coordinate;

@end
