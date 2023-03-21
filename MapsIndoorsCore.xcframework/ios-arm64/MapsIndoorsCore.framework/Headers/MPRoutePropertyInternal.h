//
//  MPRouteProperty.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 07/07/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"
@import MapsIndoors;

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Route property model
 */
@interface MPRoutePropertyInternal : JSONModel <MPRouteProperty>

/**
 Route property description.
 */
@property (nonatomic, copy, nullable) NSString* text;
/**
 Route property value.
 */
@property (nonatomic, strong, nullable) NSNumber* value;

@end
