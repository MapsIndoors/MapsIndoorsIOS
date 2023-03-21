//
//  MPCategories.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 18/01/16.
//  Copyright  Daniel Nielsen. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MPDataField;
@protocol MPDataFieldInternal;

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPCategories : JSONModel

@property (nonatomic, strong) NSArray<id<MPDataField>><MPDataFieldInternal>* list;

@end

NS_ASSUME_NONNULL_END
