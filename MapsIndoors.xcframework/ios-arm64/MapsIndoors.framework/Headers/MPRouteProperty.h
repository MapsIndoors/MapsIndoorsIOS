//
//  MPRouteProperty.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 07/07/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import "MPJSONModel.h"

/**
 Route property model
 */
@interface MPRouteProperty : MPJSONModel

/**
 Route property description.
 */
@property (nonatomic, strong, nullable) NSString* text;
/**
 Route property value.
 */
@property (nonatomic, strong, nullable) NSNumber* value;

@end
