//
//  MPRouteCoordinate.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 07/07/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Route coordinate model
 */
@interface MPRouteCoordinate : JSONModel

/**
 Floor level index
 */
@property (nonatomic, strong, readonly) NSNumber* zLevel;
/**
 Latitude angle
 */
@property (nonatomic, strong, readonly) NSNumber* lat;
/**
 Longitude angle
 */
@property (nonatomic, strong, readonly) NSNumber* lng;
/**
 Floor name for this coordinate
 */
@property (nonatomic, strong, nullable, readonly) NSString* floor_name;
/**
 Label for displaying contextual information about this coordinate
 */
@property (nonatomic, strong, nullable, readonly) NSString* label;

@end

NS_ASSUME_NONNULL_END
