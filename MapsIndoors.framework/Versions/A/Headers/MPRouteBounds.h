//
//  MPRouteBounds.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 25/09/15.
//  Copyright © 2015 MapsPeople A/S. All rights reserved.
//

#import "MPJSONModel.h"
#import "MPRouteCoordinate.h"

@interface MPRouteBounds : MPJSONModel

@property MPRouteCoordinate* northeast;
@property MPRouteCoordinate* southwest;

@end
