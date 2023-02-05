//
//  MPLiveDataManager+Private.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 16/12/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "MPLiveDataManager.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPLiveDataManager (Private)

- (void)invalidateSubscriptionState;
- (void)updateSubscriptions;

@end

NS_ASSUME_NONNULL_END
