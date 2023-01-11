//
//  MPRouteProperty.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 07/07/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"

/**
 Route property model
 */
@interface MPRouteProperty : JSONModel

/**
 Route property description.
 */
@property (nonatomic, strong, nullable, readonly) NSString* text;
/**
 Route property value.
 */
@property (nonatomic, strong, nullable, readonly) NSNumber* value;

@end
