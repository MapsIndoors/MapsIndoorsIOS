//
//  MPGeometryQueryProtocol.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 14/09/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "MPPoint.h"

@class MPGeometryContainmentMetadata;


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@protocol MPGeometryQueryProtocol <NSObject>

/**
 The area of the polygon computed as the area of the outer path with the area of all holes subtracted.
 */
@property (nonatomic, readonly) double              area;

/**
 Check if the given point is contained within the polygon.
 
 - Parameter point: point to check for containment.
 - Returns: YES of the point is inside the polygon boundary AND outside any holes in the polygon.
 - Returns: NO if the point is outside the polygon, or inside any holes in the polygon.
 */
- (BOOL) containsPoint:(nonnull MPPoint*) point;

/**
 Check if the given coordinate is contained within the polygon.

 - Parameter coordinate: coordinate to check for containment.
 - Returns: YES of the coordinate is inside the polygon boundary AND outside any holes in the polygon.
 - Returns: NO if the coordinate is outside the polygon, or inside any holes in the polygon.
 */
- (BOOL) containsCoordinate:(CLLocationCoordinate2D)coordinate;

/**
 Check if the given coordinate is contained within the polygon.
 
 - Parameter coordinate: coordinate to check for containment.
 - Parameter ignorePolygonHoles: Should holes in a polygon be ignored
 - Returns: YES of the coordinate is inside the polygon boundary AND outside any holes in the polygon.
 - Returns: NO if the coordinate is outside the polygon, or inside any holes in the polygon.
 */
- (BOOL) containsCoordinate:(CLLocationCoordinate2D)coordinate ignorePolygonHoles:(BOOL)ignorePolygonHoles;

/**
 Check if the given coordinate is contained within the polygon, and optionally return the coordinate closest to the polygon.
 If the polygon contains the coordinate, 'coordinate' is returned as nearestPoint.
 If coordinate is not contained, the nearest point is calculated.

 - Parameter coordinate: coordinate to check for containment.
 - Parameter containmentMetadata: If not nil, the nearest point and distance on the polygon boundary is returned. Note this may be the nearest point on a polygon-hole.
 - Parameter ignorePolygonHoles:  YES to ignore polygon holes.
 - Returns: NO if the coordinate is outside the polygon, or inside any holes in the polygon.
 */
- (BOOL) containsCoordinate:(CLLocationCoordinate2D)coordinate ignorePolygonHoles:(BOOL)ignorePolygonHoles containmentMetadata:(nullable MPGeometryContainmentMetadata*)containmentMetadata;

/**
 Check if the given linesegment is fully contained within the polygon.

 - Parameter u: start coordinate of linesegment to check for containment.
 - Parameter v: end coordinate of linesegment to check for containment.
 - Returns: YES of the linesegment is fully inside the polygon boundary AND outside any holes in the polygon.
 - Returns: NO if the linesegment is not fully inside the polygon, or inside any holes in the polygon.
 */
- (BOOL) containsLineSegmentFromCoordinate:(CLLocationCoordinate2D)u toCoordinate:(CLLocationCoordinate2D)v;

@end
