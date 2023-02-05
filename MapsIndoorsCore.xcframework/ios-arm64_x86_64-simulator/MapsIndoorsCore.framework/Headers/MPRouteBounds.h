//
//  MPRouteBounds.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 25/09/15.
//  Copyright © 2015 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"
#import "MPRouteCoordinate.h"

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Route bounds model
 */
@interface MPRouteBounds : JSONModel

/**
 North east corner coordinate.
 */
@property (nonatomic, strong, nullable, readonly) MPRouteCoordinate* northeast;
/**
 South west corner coordinate.
 */
@property (nonatomic, strong, nullable, readonly) MPRouteCoordinate* southwest;

@end
