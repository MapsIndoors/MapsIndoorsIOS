//
//  MPCategories.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 18/01/16.
//  Copyright © 2016 Daniel Nielsen. All rights reserved.
//

@import JSONModel;
#import "MPDataField.h"

@protocol MPDataField
@end

@interface MPCategories : JSONModel

@property (nonatomic, strong) NSArray<MPDataField>* list;

@end
