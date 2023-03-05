//
//  MPPolygonGeometry.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 07/05/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "MPGeometry.h"
#import "MPGeometryQueryProtocol.h"

@class GMSPath;

@interface MPPolygonGeometry : MPGeometry <MPGeometryQueryProtocol>

/**
 The polygon boundary.  Consists of pairs of [longitude, latitude].
 */
@property (nonatomic, readonly, nullable) NSArray<NSArray<NSNumber*>*>* path;

/**
 Get a GMSPath representing the path of the polygon.

 @return GMSPath
 */
- (nullable GMSPath*) gmsPathForPath;

/**
 Optional array of polygon holes.
 A polygon hole is an array of [longitude, latitude] pairs.
 */
@property (nonatomic, readonly, nullable) NSArray<NSArray<NSArray<NSNumber*>*>*>* holes;

/**
 Return an array of GMSPaths for the hole in the polygon.

 @return Array of GMSPaths, nil if the polygon have no holes.
 */
- (nullable NSArray<GMSPath*>*) gmsPathsForHoles;


@end
