//
//  MPRouteProperty.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 07/07/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import "MPJSONModel.h"

@interface MPRouteProperty : MPJSONModel

@property (nonatomic, strong, nullable) NSString* text;
@property (nonatomic, strong, nullable) NSNumber* value;

@end
