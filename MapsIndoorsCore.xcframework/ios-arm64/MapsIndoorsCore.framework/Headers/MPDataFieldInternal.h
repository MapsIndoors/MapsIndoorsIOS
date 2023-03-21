//
//  MPDataField.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 20/10/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"
@import MapsIndoors;

@protocol MPLocationFieldInternal;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Data field model, e.g. used for categories.
 */
@interface MPDataFieldInternal : JSONModel <MPDataField>
/**
 Get the key of the data field.
 */
@property (nonatomic, copy) NSString* key;
/**
 Get the value of the data field.
 */
@property (nonatomic, copy, nullable) NSString* value;
/**
 Dictionary of custom fields
 */
@property (nonatomic, copy, nullable) NSDictionary<NSString*, id<MPLocationField>><MPLocationFieldInternal>* fields;

@end

NS_ASSUME_NONNULL_END
