//
//  MPMenuItem.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 08/08/16.
//  Copyright  Daniel Nielsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@protocol MPMenuItem
@end

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPMenuItem : JSONModel

@property (nonatomic, strong, nullable) NSString<Optional>* categoryKey;
@property (nonatomic, strong, nullable) NSString<Optional>* menuImageUrl;
@property (nonatomic, strong, nullable) NSString<Optional>* iconUrl;

@end

