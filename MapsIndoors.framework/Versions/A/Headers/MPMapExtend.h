//
//  MPMapExtend.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 18/03/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>


@interface MPMapExtend : NSObject

- (nullable instancetype)initWithGMSBounds:(nullable GMSCoordinateBounds*)bounds;

@property double south;
@property double west;
@property double north;
@property double east;

@end
