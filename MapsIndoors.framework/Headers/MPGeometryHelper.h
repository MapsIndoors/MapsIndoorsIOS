//
//  MPGeometryHelper.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 15/09/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface MPGeometryHelper : NSObject

/**
 Calculates distance from a coordinate to the nearest point on a finite line defined by coordinates

 @param p The coordinate to calculate the distance from
 @param v The start coordinate on the finite line
 @param w The end coordinate on the finite line
 @return The distance in meters
 */
+ (double) coordinateToLineDistance: (CLLocationCoordinate2D) p toLineSegmentV: (CLLocationCoordinate2D) v andW: (CLLocationCoordinate2D) w;

/**
 Given a finite line UV, calculate the closest coordinate on that line to another coordinate P

 @param coordinateP The
 @param coordinateU The start coordinate on the finite line
 @param coordinateV The end coordinate on the finite line
 @return The closest coordinate on the line
 */
+ (CLLocationCoordinate2D) closestCoordinateOnLineSegment:(CLLocationCoordinate2D)coordinateP coordinateU: (CLLocationCoordinate2D)coordinateU coordinateV: (CLLocationCoordinate2D)coordinateV;

/**
 Distance in meters between coordinates

 @param from The first coordinate
 @param to The second coordinate
 @return The distance in meters
 */
+ (double) distanceFromCoordinate:(CLLocationCoordinate2D)from toCoordinate:(CLLocationCoordinate2D)to;
/**
 Angle in degrees between coordinates relative to north. Angle will be 0 when both coordinates have the same longitude and the second coordinates latitude is equal to or larger than the first coordinate.
 
 @param from The first coordinate
 @param to The second coordinate
 @return The angle in degrees
 */
+ (double) angleFromCoordinate:(CLLocationCoordinate2D) from toCoordinate:(CLLocationCoordinate2D)to;

/**
 Check if a coordinate is inside a polygon

 @param bounds polygon bounds
 @param point coordinate point
 @return Whether the coordinate is inside the polygon
 */
+ (BOOL) boundsContainsCoordinate: (NSArray<NSArray<NSNumber*>*>*) bounds coordinate:(CLLocationCoordinate2D) point;

@end
