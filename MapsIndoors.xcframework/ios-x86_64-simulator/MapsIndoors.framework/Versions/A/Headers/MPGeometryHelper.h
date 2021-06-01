//
//  MPGeometryHelper.h
//  MapsIndoors App
//
//  Created by Daniel Nielsen on 17/04/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPPolygonGeometry.h"
#import "MPLocation.h"

NS_ASSUME_NONNULL_BEGIN


/**
 Geometry helper methods
 */
@interface MPGeometryHelper : NSObject


/**
 Get Location polygon geometries if applicable. Some locations have multi polygons which is why this method returns an array.

 @param location Location object to get polygon geometries from
 @return Array of polygons
 */
+ (NSArray<MPPolygonGeometry*>* _Nullable) polygonsForLocation:(MPLocation*)location;

@end

NS_ASSUME_NONNULL_END
