//
//  MPLiveDataManager+Private.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 16/12/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "MPLiveDataManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPLiveDataManager (Private)

@property (nonatomic, strong, readonly, nullable) NSArray<NSString*>* domainTypesForCurrentDataset;
- (void)invalidateSubscriptionState;
- (void)updateSubscriptions;

@end

NS_ASSUME_NONNULL_END
