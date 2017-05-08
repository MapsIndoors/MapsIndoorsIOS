//
//  MPCategories.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 18/01/16.
//  Copyright  Daniel Nielsen. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MPDataField.h"

@protocol MPDataField
@end

@interface MPCategories : JSONModel

@property (nonatomic, strong) NSArray<MPDataField>* list;

@end
