//
//  MPDataSetCacheInternal.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 03/02/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapsIndoors;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
Data set cache class.
*/
@interface MPDataSetCacheInternal : NSObject<MPDataSetCache>

/**
Data set id.
*/
@property (nonatomic, copy, readonly) NSString* dataSetId;

/**
Dataset name.
*/
@property (nonatomic, copy, readonly) NSString* name;

/**
Caching strategy for the data set.
*/
@property (nonatomic, readonly) MPDataSetCachingStrategy cachingStrategy;

/**
Cache item for caching the full data set.
*/
@property (nonatomic, strong, readonly) id<MPDataSetCacheItem> cacheItem;

// CacheItems for per-venue caching:
//- perVenueCacheItems: MPDataSetCacheItem[]

@property (nonatomic, readonly) BOOL                            isSyncing;

/**
 YES if this dataset has data bundled inside the application, else NO.
 */
@property (nonatomic, readonly) BOOL                            haveBundledData;

@end

NS_ASSUME_NONNULL_END
