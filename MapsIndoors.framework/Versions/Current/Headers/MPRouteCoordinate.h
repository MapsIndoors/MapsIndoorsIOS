//
//  MPRouteCoordinate.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 07/07/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import "MPJSONModel.h"

@interface MPRouteCoordinate : MPJSONModel

@property (nonatomic, strong, nullable) NSNumber<Optional>* zLevel;
@property (nonatomic, strong, nullable) NSNumber* lat;
@property (nonatomic, strong, nullable) NSNumber* lng;
@property (nonatomic, strong, nullable) NSString<Optional>* floor_name;

@end
