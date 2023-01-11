//
//  MPCategories.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 18/01/16.
//  Copyright  Daniel Nielsen. All rights reserved.
//

#import "JSONModel.h"

NS_ASSUME_NONNULL_BEGIN

@class MPDataField;
@protocol MPDataField;

@interface MPCategories : JSONModel

@property (nonatomic, strong) NSArray<MPDataField*><MPDataField>* list;

@end

NS_ASSUME_NONNULL_END
