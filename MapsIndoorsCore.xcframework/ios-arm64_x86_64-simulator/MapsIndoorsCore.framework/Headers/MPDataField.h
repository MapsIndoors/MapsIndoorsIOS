//
//  MPDataField.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 20/10/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "MPLocationField.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MPLocationField;

/**
 Data field model, e.g. used for categories.
 */
@interface MPDataField : JSONModel
/**
 Get the key of the data field.
 */
@property (nonatomic, strong, readonly) NSString* key;
/**
 Get the value of the data field.
 */
@property (nonatomic, strong, nullable, readonly) NSString<Optional>* value;
/**
 Dictionary of custom fields
 */
@property (nonatomic, strong, nullable, readonly) NSDictionary<NSString*, MPLocationField*><Optional, MPLocationField>* fields;

@end

NS_ASSUME_NONNULL_END
