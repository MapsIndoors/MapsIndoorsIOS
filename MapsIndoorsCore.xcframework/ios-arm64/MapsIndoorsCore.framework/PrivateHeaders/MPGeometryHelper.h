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

@class MPPoint;

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPGeometryHelper: NSObject

/**
 Calculates distance from a coordinate to the nearest point on a finite line defined by coordinates

 - Parameter p: The coordinate to calculate the distance from
 - Parameter v: The start coordinate on the finite line
 - Parameter w: The end coordinate on the finite line
 - Returns: The distance
 */
+ (double) coordinateToLineDistance: (CLLocationCoordinate2D) p toLineSegmentV: (CLLocationCoordinate2D) v andW: (CLLocationCoordinate2D) w;

/**
 Calculates squared distance from a coordinate to the nearest point on a finite line defined by coordinates
 
 - Parameter coordinateP: The coordinate to calculate the squared distance from
 - Parameter coordinateV: The start coordinate on the finite line
 - Parameter coordinateW: The end coordinate on the finite line
 - Returns: The squared distance
 */
+ (double) coordinateToLineDistanceSquared: (CLLocationCoordinate2D) coordinateP toLineSegmentV: (CLLocationCoordinate2D) coordinateV andW: (CLLocationCoordinate2D) coordinateW;


/**
 Given a finite line UV, calculate the closest coordinate on that line to another coordinate P

 - Parameter coordinateP: The
 - Parameter coordinateU: The start coordinate on the finite line
 - Parameter coordinateV: The end coordinate on the finite line
 - Returns: The closest coordinate on the line
 */
+ (CLLocationCoordinate2D) closestCoordinateOnLineSegment:(CLLocationCoordinate2D)coordinateP coordinateU: (CLLocationCoordinate2D)coordinateU coordinateV: (CLLocationCoordinate2D)coordinateV;

/**
 Distance in meters between coordinates

 - Parameter from: The first coordinate
 - Parameter to: The second coordinate
 - Returns: The distance in meters
 */
+ (double) distanceFromCoordinate:(CLLocationCoordinate2D)from toCoordinate:(CLLocationCoordinate2D)to;

/**
 Determine if two CLLocationCoordinate2Ds are the same.
 - Returns: YES if the same, else NO.
 */
+ (BOOL) coordinate:(CLLocationCoordinate2D)coordinate1 isEqualToCoordinate:(CLLocationCoordinate2D)coordinate2;

/**
 Angle in degrees between coordinates relative to north. Angle will be 0 when both coordinates have the same longitude and the second coordinates latitude is equal to or larger than the first coordinate.
 
 - Parameter from: The first coordinate
 - Parameter to: The second coordinate
 - Returns: The angle in degrees
 */
+ (double) angleFromCoordinate:(CLLocationCoordinate2D) from toCoordinate:(CLLocationCoordinate2D)to;

/**
 Check if a coordinate is inside a polygon

 - Parameter bounds: polygon bounds
 - Parameter point: coordinate point
 - Returns: Whether the coordinate is inside the polygon
 */
+ (BOOL) boundsContainsCoordinate: (nonnull NSArray<NSArray<MPPoint*>*>*) bounds coordinate:(CLLocationCoordinate2D) point;

/**
 Sort an array of points according to distance to a linesegment.
 Example use is sorting venue-entrypoints according to line-of-flight between origin and destion points (assume flat earth).

 - Parameter points: Array of points to order
 - Parameter coordinateV: The start coordinate on the finite line
 - Parameter coordinateW: The end coordinate on the finite line
 - Returns: Sorted array of points.
 */
+ (nonnull NSArray*) orderPoints:(nonnull NSArray<MPPoint*>*)points byDistanceToLineSegmentV:(nonnull MPPoint*)coordinateV andW:(nonnull MPPoint*)coordinateW;

/**
 Sort an array of points according to distance to a reference point.

 - Parameter points: Array of points to order
 - Parameter refPoint: Reference point
 - Returns: Sorted array of points.
 */
+ (nonnull NSArray*) orderPoints:(nonnull NSArray<MPPoint*>*)points byDistanceToPoint:(nonnull MPPoint*)refPoint;

/**
 Converts coordinates of latitude longitude to pixel values at a given zoom level

 - Parameter coordinates: The lat/lng coordinate
 - Parameter zoom: The map zoom level at which the conversion should be performed
 - Returns: A CGPoint with pixel
 */
+ (CGPoint) fromCoordinatesToPixel:(CLLocationCoordinate2D) coordinates atZoom: (double) zoom;

/**
Calculates a point in a Quadratic Bézier Curve

- Parameter p0: The start point
- Parameter p1: The control point
- Parameter p2: The end point
- Parameter t: The interpolation factor (0-1)
- Returns: A CLLocationCoordinate2D
*/
+ (CGPoint) pointInQuadCurve:(CGPoint) p0 p1: (CGPoint) p1 p2: (CGPoint) p2 t: (float) t;

/**
Calculates a liear interpolated point between two points

- Parameter a: The start point
- Parameter b: The end point
- Parameter t: The interpolation factor (0-1)
- Returns: A CGPoint
*/
+ (CGPoint) interpolate:(CGPoint) a b: (CGPoint) b t: (float) t;

@end
