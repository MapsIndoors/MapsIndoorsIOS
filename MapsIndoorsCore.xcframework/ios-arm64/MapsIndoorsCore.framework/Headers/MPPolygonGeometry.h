//
//  MPPolygonGeometry.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 07/05/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//


#import "MPGeometry.h"
#import "MPGeometryQueryProtocol.h"


@class MPGeometryContainmentMetadata;
@protocol MPPath;
@class CorePolyline;


@interface MPPolygonGeometry : MPGeometry <MPGeometryQueryProtocol>

/**
 The polygon boundary.  Consists of pairs of [longitude, latitude].
 */
@property (nonatomic, readonly, nullable) NSArray<NSArray<NSNumber*>*>* path;

/**
 Get a MPPath representing the path of the polygon.

 @return MPPath
 */
- (nullable id<MPPath>) mpPathForPath;

/**
 Optional array of polygon holes.
 A polygon hole is an array of [longitude, latitude] pairs.
 */
@property (nonatomic, readonly, nullable) NSArray<NSArray<NSArray<NSNumber*>*>*>* holes;

/**
 Return an array of MPPaths for the hole in the polygon.

 @return Array of MPPath, nil if the polygon have no holes.
 */
- (nullable NSArray<CorePolyline*>*) mpPathsForHoles;


@end
