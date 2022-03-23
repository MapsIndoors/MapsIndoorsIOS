//
//  MPQuery+Private.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 06/11/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "MPQuery.h"
#import "MIQuery.h"
#import "MIOrdering.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPQuery (Private)

@property (nonatomic, readonly) MIQuery* miQuery;
@property (nonatomic) NSMutableArray<MIOrdering*>* miOrdering;

@end

NS_ASSUME_NONNULL_END
