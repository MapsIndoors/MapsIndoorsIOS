//
//  MPGeometryHelper+Private.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 15/09/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "MPGeometryHelper.h"

@class MPPoint;

@interface MPGeometryHelper (Private)

/**
 Calculates distance from a coordinate to the nearest point on a finite line defined by coordinates

 @param p The coordinate to calculate the distance from
 @param v The start coordinate on the finite line
 @param w The end coordinate on the finite line
 @return The distance
 */
+ (double) coordinateToLineDistance: (CLLocationCoordinate2D) p toLineSegmentV: (CLLocationCoordinate2D) v andW: (CLLocationCoordinate2D) w;

/**
 Calculates squared distance from a coordinate to the nearest point on a finite line defined by coordinates
 
 @param coordinateP The coordinate to calculate the squared distance from
 @param coordinateV The start coordinate on the finite line
 @param coordinateW The end coordinate on the finite line
 @return The squared distance
 */
+ (double) coordinateToLineDistanceSquared: (CLLocationCoordinate2D) coordinateP toLineSegmentV: (CLLocationCoordinate2D) coordinateV andW: (CLLocationCoordinate2D) coordinateW;


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
 Determine if two CLLocationCoordinate2Ds are the same.
 @return YES if the same, else NO.
 */
+ (BOOL) coordinate:(CLLocationCoordinate2D)coordinate1 isEqualToCoordinate:(CLLocationCoordinate2D)coordinate2;

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
+ (BOOL) boundsContainsCoordinate: (nonnull NSArray<NSArray<NSNumber*>*>*) bounds coordinate:(CLLocationCoordinate2D) point;

/**
 Sort an array of points according to distance to a linesegment.
 Example use is sorting venue-entrypoints according to line-of-flight between origin and destion points (assume flat earth).

 @param points Array of points to order
 @param coordinateV The start coordinate on the finite line
 @param coordinateW The end coordinate on the finite line
 @return Sorted array of points.
 */
+ (nonnull NSArray*) orderPoints:(nonnull NSArray<MPPoint*>*)points byDistanceToLineSegmentV:(nonnull MPPoint*)coordinateV andW:(nonnull MPPoint*)coordinateW;

/**
 Sort an array of points according to distance to a reference point.

 @param points Array of points to order
 @param refPoint Reference point
 @return Sorted array of points.
 */
+ (nonnull NSArray*) orderPoints:(nonnull NSArray<MPPoint*>*)points byDistanceToPoint:(nonnull MPPoint*)refPoint;

/**
 Converts coordinates of latitude longitude to pixel values at a given zoom level

 @param coordinates The lat/lng coordinate
 @param zoom The map zoom level at which the conversion should be performed
 @return A CGPoint with pixel
 */
+ (CGPoint) fromCoordinatesToPixel:(CLLocationCoordinate2D) coordinates atZoom: (double) zoom;

/**
Calculates a point in a Quadratic Bézier Curve

@param p0 The start point
@param p1 The control point
@param p2 The end point
@param t The interpolation factor (0-1)
@return A CLLocationCoordinate2D
*/
+ (CGPoint) pointInQuadCurve:(CGPoint) p0 p1: (CGPoint) p1 p2: (CGPoint) p2 t: (float) t;

/**
Calculates a liear interpolated point between two points

@param a The start point
@param b The end point
@param t The interpolation factor (0-1)
@return A CGPoint
*/
+ (CGPoint) interpolate:(CGPoint) a b: (CGPoint) b t: (float) t;

/**
 Determine if two linesegments intersect, and optionally return the intersection point

 @param p1 start of 1st linesegment
 @param p2 end of 1st linesegment
 @param p3 start of 2nd linesegment
 @param p4 end of 2nd linesegment
 @param pIntersection optional receiver of intersection point.
 @return YES if linesegments intersect, else NO
 */
+ (BOOL) intersectionOfLineFrom:(CLLocationCoordinate2D)p1 to:(CLLocationCoordinate2D)p2 withLineFrom:(CLLocationCoordinate2D)p3 to:(CLLocationCoordinate2D)p4 intersection:(CLLocationCoordinate2D*_Nullable)pIntersection;

@end
