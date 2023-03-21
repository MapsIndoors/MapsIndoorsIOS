//
//  MPQuery+Private.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 06/11/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "MIQuery.h"
@import MapsIndoors;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPQuery (Private)

@property (nonatomic, readonly) MIQuery* miQuery;

@end

NS_ASSUME_NONNULL_END
