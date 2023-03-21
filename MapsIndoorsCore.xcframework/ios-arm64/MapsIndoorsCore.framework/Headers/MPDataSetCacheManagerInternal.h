//
//  MPDataSetManager.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 31/01/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapsIndoors;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Data set manager class.
 */
@interface MPDataSetCacheManagerInternal : NSObject <MPDataSetCacheManager>

/**
 Construction not allowed - use MapsIndoors.dataSetCacheManager to access the cache manager.
 */
+ (instancetype) new NS_UNAVAILABLE;

/**
 Construction not allowed - use MapsIndoors.dataSetCacheManager to access the cache manager.
 */
- (instancetype) init NS_UNAVAILABLE;

/**
 Data set manager delegate.
 */
@property (nonatomic, nullable, retain) id<MPDataSetCacheManagerDelegate> delegate;

/**
 List of managed data sets.
 */
@property (nonatomic, copy, readonly) NSArray<id<MPDataSetCache>>* managedDataSets;

/**
 Synchronization state of manager. If true, the manager is currently synchronising.
 */
@property (nonatomic, readonly) BOOL isSyncing;

/**
 Add data set to the list of managed data sets.

 - Parameter dataSetId: Data set id of the data set that should be added.
 - Returns: The cache object if data set was successfully added as a result of this call, if the dataset already existed this method returns nil.
 */
- (nullable id<MPDataSetCache>) addDataSet:(NSString*)dataSetId;

/**
 Add data set to the list of managed data sets.

 - Parameter dataSetId: Data set id of the data set that should be added.
 - Parameter scope: Caching scope for this dataset.
 - Returns: The cache object if data set was successfully added as a result of this call, if the dataset already existed this method returns nil.
*/
- (nullable id<MPDataSetCache>) addDataSet:(NSString*)dataSetId cachingScope: (MPDataSetCachingScope) scope;

/**
 Remove data set from the list of managed data sets. This will remove any cached content for that data set as well.
 If the dataset to be removed is the current MapsIndoors dataset, it is not removed at this time, but scheduled for deletion at a later time.
 
 - Parameter dataSet: Data set that should be removed.
 - Returns: YES if data set was successfully removed, else NO.
 */
- (BOOL) removeDataSet:(id<MPDataSetCache>)dataSet;

/**
 Get the dataset-object for the given dataSetId.
 - Parameter dataSetId: dataSetId to find corresponding MPDataSetCache object for.
 - Returns: MPDataSetCache* or nil
 */
- (nullable id<MPDataSetCache>) dataSetWithId:(NSString*)dataSetId;

/**
Get the dataset-object for the current MapsIndoors API key / solution
- Returns: MPDataSetCache*
*/
- (nullable id<MPDataSetCache>) dataSetForCurrentMapsIndoorsAPIKey;

/**
 Set a caching strategy for given cache item.

 - Parameter strategy: Caching strategy.
 - Parameter cacheItem: Cache item.
 - Returns: YES if strategy is set for this item, else NO.
 */
- (BOOL) setCachingStrategy:(MPDataSetCachingStrategy) strategy cacheItem: (id<MPDataSetCacheItem>)cacheItem;

/**
 Set a caching scope for given cache item.

 - Parameter scope: Caching scope.
 - Parameter cacheItem: Cache item.
 - Returns: YES if strategy is changed for this item, else NO.
 */
- (BOOL) setCachingScope:(MPDataSetCachingScope)scope cacheItem: (id<MPDataSetCacheItem>)cacheItem;

/**
 Fetch and update content for all managed data sets. The delegate object receives the completion event.
 */
- (void) synchronizeContent;

/**
 Fetch and update content for given cache items. The delegate object receives the completion event.

 - Parameter items: The cache items to perform a synchronisation for.
 */
- (void) synchronizeCacheItems:(NSArray<id<MPDataSetCacheItem>>*)items;

/**
 Cancel any running synchronization of data sets.
 */
- (void) cancelSynchronization;

/**
 Cancel synchronization of data for the given cache items.
 - Parameter items: CacheItems to cancel sync of.
 */
- (void) cancelSynchronizationOfCacheItems:(NSArray<id<MPDataSetCacheItem>>*)items;


/**
 Determine synchronization sizes for the given set of MPDataSetCaches.
 - Parameter dataSetCaches:    MPDataSetCaches to determine sync sizes for.
 - Parameter delegate:     callback/progress receiver
 */
- (void) fetchSyncSizesForDataSetCaches:(NSArray<id<MPDataSetCache>>*)dataSetCaches delegate:(id<MPDataSetCacheManagerSizeDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
