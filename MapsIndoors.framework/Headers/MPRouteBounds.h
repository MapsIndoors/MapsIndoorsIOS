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

@property (nonatomic, strong, nullable) MPRouteCoordinate* northeast;
@property (nonatomic, strong, nullable) MPRouteCoordinate* southwest;

@end
