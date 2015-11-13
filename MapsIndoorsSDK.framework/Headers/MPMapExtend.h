//
//  MPMapExtend.h
//  MapsIndoorSDK
//
//  Created by Daniel Nielsen on 18/03/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifdef USE_M4B
#import <GoogleMapsM4B/GoogleMaps.h>
#else
#import <GoogleMaps/GoogleMaps.h>
#endif
@interface MPMapExtend : NSObject

- (id)initWithGMSBounds:(GMSCoordinateBounds*)bounds;

@property double south;
@property double west;
@property double north;
@property double east;

@end
