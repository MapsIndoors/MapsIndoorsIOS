//
//  MPRouteBoundsInternal.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 25/09/15.
//  Copyright © 2015 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"
#import "MPRouteCoordinateInternal.h"

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Route bounds model
 */
@interface MPRouteBoundsInternal : JSONModel <MPRouteBounds>

/**
 North east corner coordinate.
 */
@property (nonatomic, strong, nullable) MPRouteCoordinateInternal* northeast;
/**
 South west corner coordinate.
 */
@property (nonatomic, strong, nullable) MPRouteCoordinateInternal* southwest;

@end
