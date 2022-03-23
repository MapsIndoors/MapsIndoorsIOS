//
//  MPLocationProperty.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 1/22/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Creates a location property, holding a type identifier and a value
 */
@interface MPLocationProperty : NSObject

@property (nonatomic, strong, nullable) NSString* propertyType;
@property (nonatomic, strong, nullable) NSObject* propertyValue;

/**
 Initialization that takes a type identifier and a value
 */
- (nullable instancetype)initWithValue:(nullable NSObject*)value andType:(nullable NSString*)type;

@end
