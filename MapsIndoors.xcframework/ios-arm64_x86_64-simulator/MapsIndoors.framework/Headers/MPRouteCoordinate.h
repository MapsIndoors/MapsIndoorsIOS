//
//  MPRouteCoordinate.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 07/07/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"

/**
 Route coordinate model
 */
@interface MPRouteCoordinate : JSONModel

/**
 Floor level index
 */
@property (nonatomic, strong, nullable) NSNumber<Optional>* zLevel;
/**
 Latitude angle
 */
@property (nonatomic, strong, nullable) NSNumber* lat;
/**
 Longitude angle
 */
@property (nonatomic, strong, nullable) NSNumber* lng;
/**
 Floor name for this coordinate
 */
@property (nonatomic, strong, nullable) NSString<Optional>* floor_name;
/**
 Label for displaying contextual information about this coordinate
 */
@property (nonatomic, strong, nullable) NSString<Optional>* label;

@end
