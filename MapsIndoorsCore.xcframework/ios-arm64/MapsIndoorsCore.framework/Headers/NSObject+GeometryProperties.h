//
//  NSObject+GeometryProperties.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 14/09/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapsIndoors;

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface NSObject (GeometryProperties)

/**
 Get the locations polygon (if any)
 */
@property (nonatomic, strong, setter=mp_setPolygon:) MPPolygonGeometry* mp_polygon;

/**
 Get the locations MultiPolygon (if any)
 */
@property (nonatomic, strong, setter=mp_setMultiPolygon:) MPMultiPolygonGeometry* mp_multiPolygon;

/**
 Get the effective geometry interface.
 Shorthand for querying which of .polygon and .multiPolygon to use. (Possibly we'll get more types in the future)
 */
@property (nonatomic, weak, readonly) id<MPGeometryQueryProtocol>   mp_effectiveGeometry;

@end
