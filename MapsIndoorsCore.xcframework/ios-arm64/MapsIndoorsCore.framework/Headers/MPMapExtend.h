//
//  MPMapExtend.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 18/03/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//
#import <Foundation/Foundation.h>


@protocol MPCoordinateBounds;

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPMapExtend : NSObject

- (nullable instancetype)initWithBounds:(nullable id<MPCoordinateBounds>)bounds;

- (nullable instancetype)initWithCoords:(double)neLat neLng:(double)neLng swLat:(double)swLat swLng:(double)swLng;

@property double south;
@property double west;
@property double north;
@property double east;

@end

