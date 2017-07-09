//
//  MPRouteInfo.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 8/9/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import "MPJSONModel.h"

/**
 Route info model
 */
__attribute__((deprecated))
@interface MPRouteInfo : MPJSONModel

//@property BOOL routeFound;
@property float took;
@property double tookGeocoding;

@end
