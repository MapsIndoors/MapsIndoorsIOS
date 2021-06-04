//
//  MPPolygonGeometry.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 07/05/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPGeometry.h"
#import "MPGeometryQueryProtocol.h"


@class MPGeometryContainmentMetadata;


@interface MPPolygonGeometry : MPGeometry <MPGeometryQueryProtocol>

/**
 The polygon boundary.  Consists of pairs of [longitude, latitude].
 */
@property (nonatomic, readonly, nullable) NSArray<NSArray<NSNumber*>*>* path;

/**
 Optional array of polygon holes.
 A polygon hole is an array of [longitude, latitude] pairs.
 */
@property (nonatomic, readonly, nullable) NSArray<NSArray<NSArray<NSNumber*>*>*>* holes;


@end
