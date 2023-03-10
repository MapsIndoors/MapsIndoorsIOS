//
//  MPCategories.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 18/01/16.
//  Copyright  Daniel Nielsen. All rights reserved.
//

#import "JSONModel.h"

@class MPDataField;
@protocol MPDataField;

@interface MPCategories : JSONModel

@property (nonatomic, strong, nullable) NSArray<MPDataField*><MPDataField>* list;

@end
