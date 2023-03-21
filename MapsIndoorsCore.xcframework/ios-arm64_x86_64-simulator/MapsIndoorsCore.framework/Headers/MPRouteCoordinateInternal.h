//
//  MPRouteCoordinateInternal.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 07/07/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"
@import MapsIndoors;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Route coordinate model
 */
@interface MPRouteCoordinateInternal : JSONModel<MPRouteCoordinate>

/**
 Floor level index
 */
@property (nonatomic, strong) NSNumber* zLevel;
/**
 Latitude angle
 */
@property (nonatomic, strong) NSNumber* lat;
/**
 Longitude angle
 */
@property (nonatomic, strong) NSNumber* lng;
/**
 Floor name for this coordinate
 */
@property (nonatomic, copy, nullable) NSString* floor_name;
/**
 Label for displaying contextual information about this coordinate
 */
@property (nonatomic, copy, nullable) NSString* label;

@end

NS_ASSUME_NONNULL_END
