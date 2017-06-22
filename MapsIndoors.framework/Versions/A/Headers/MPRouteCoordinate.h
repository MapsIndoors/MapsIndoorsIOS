//
//  MPRouteCoordinate.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 07/07/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"

@interface MPRouteCoordinate : JSONModel

@property (nonatomic) NSNumber<Optional>* zLevel;
@property NSNumber* lat;
@property NSNumber* lng;
@property NSString<Optional>* floor_name;

@end
