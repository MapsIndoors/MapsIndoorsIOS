//
//  MPRouteInfo.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 8/9/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"

/**
 * Rounting is under development.
 */
__attribute__((deprecated))
@interface MPRouteInfo : JSONModel

//@property BOOL routeFound;
@property float took;
@property double tookGeocoding;

@end
