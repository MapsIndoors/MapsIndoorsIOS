//
//  NSObject+GeometryProperties.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 14/09/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MPMultiPolygonGeometry;
@class MPPolygonGeometry;
@protocol Ignore;
@protocol MPGeometryQueryProtocol;

@interface NSObject (GeometryProperties)

/**
 Get the locations polygon (if any)
 */
@property (nonatomic, strong, setter=mp_setPolygon:) MPPolygonGeometry<Ignore>* mp_polygon;

/**
 Get the locations MultiPolygon (if any)
 */
@property (nonatomic, strong, setter=mp_setMultiPolygon:) MPMultiPolygonGeometry<Ignore>* mp_multiPolygon;

/**
 Get the effective geometry interface.
 Shorthand for querying which of .polygon and .multiPolygon to use. (Possibly we'll get more types in the future)
 */
@property (nonatomic, weak, readonly) id<MPGeometryQueryProtocol>   mp_effectiveGeometry;

@end
