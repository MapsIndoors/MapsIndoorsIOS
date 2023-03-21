//
//  MPMenuItem.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 08/08/16.
//  Copyright  Daniel Nielsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@import MapsIndoors;

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPMenuItem : JSONModel <MPMenuInfo>

@property (nonatomic, copy, nullable) NSString* categoryKey;
@property (nonatomic, copy, nullable) NSString* menuImageUrl;
@property (nonatomic, copy, nullable) NSString* iconUrl;

@end

