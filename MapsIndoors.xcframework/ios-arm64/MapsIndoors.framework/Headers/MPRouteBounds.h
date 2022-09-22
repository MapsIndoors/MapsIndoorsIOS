//
//  MPRouteBounds.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 25/09/15.
//  Copyright © 2015 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"
#import "MPRouteCoordinate.h"

/**
 Route bounds model
 */
@interface MPRouteBounds : JSONModel

/**
 North east corner coordinate.
 */
@property (nonatomic, strong, nullable) MPRouteCoordinate* northeast;
/**
 South west corner coordinate.
 */
@property (nonatomic, strong, nullable) MPRouteCoordinate* southwest;

@end
