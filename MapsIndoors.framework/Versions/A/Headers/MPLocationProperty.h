//
//  MPLocationProperty.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 1/22/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Creates a location property, holding a type identifier and a value
 */
@interface MPLocationProperty : NSObject

@property NSString* propertyType;
@property NSObject* propertyValue;

/**
 * Initialization that takes a type identifier and a value
 */
- (id)initWithValue:(NSObject*)value andType:(NSString*)type;

@end
