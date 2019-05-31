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


@protocol MPGeometryQueryProtocol <NSObject>

/**
 The area of the polygon computed as the area of the outer path with the area of all holes subtracted.
 */
@property (nonatomic, readonly) double              area;

/**
 Check if the given point is contained within the polygon.

 @param point point to check for containment.
 @return YES of the point is inside the polygon boundary AND outside any holes in the polygon.
 @retrun NO if the point is outside the polygon, or inside any holes in the polygon.
 */
- (BOOL) containsPoint:(nonnull MPPoint*) point;

/**
 Check if the given coordinate is contained within the polygon.

 @param coordinate coordinate to check for containment.
 @return YES of the coordinate is inside the polygon boundary AND outside any holes in the polygon.
 @retrun NO if the coordinate is outside the polygon, or inside any holes in the polygon.
 */
- (BOOL) containsCoordinate:(CLLocationCoordinate2D)coordinate;

/**
 Check if the given coordinate is contained within the polygon.

 @param coordinate coordinate to check for containment.
 @return YES of the coordinate is inside the polygon boundary AND outside any holes in the polygon.
 @return NO if the coordinate is outside the polygon, or inside any holes in the polygon.
 */
- (BOOL) containsCoordinate:(CLLocationCoordinate2D)coordinate ignorePolygonHoles:(BOOL)ignorePolygonHoles;

/**
 Check if the given coordinate is contained within the polygon, and optionally return the coordinate closest to the polygon.
 If the polygon contains the coordinate, 'coordinate' is returned as nearestPoint.
 If coordinate is not contained, the nearest point is calculated.

 @param coordinate coordinate to check for containment.
 @param containmentMetadata If not nil, the nearest point and distance on the polygon boundary is returned. Note this may be the nearest point on a polygon-hole.
 @param ignorePolygonHoles  YES to ignore polygon holes.
 @return NO if the coordinate is outside the polygon, or inside any holes in the polygon.
 */
- (BOOL) containsCoordinate:(CLLocationCoordinate2D)coordinate ignorePolygonHoles:(BOOL)ignorePolygonHoles containmentMetadata:(nullable MPGeometryContainmentMetadata*)containmentMetadata;

@end
