//
//  MPDataSetManager.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 31/01/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPDataSetEnums.h"


NS_ASSUME_NONNULL_BEGIN


@class MPDataSetCache;
@class MPDataSetCacheItem;
@protocol MPDataSetCacheManagerDelegate;
@protocol MPDataSetCacheManagerSizeDelegate;


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Data set manager class.
 */
@interface MPDataSetCacheManager : NSObject

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
@property (nonatomic, nullable, weak) id<MPDataSetCacheManagerDelegate> delegate;

/**
 List of managed data sets.
 */
@property (nonatomic, strong, readonly) NSArray<MPDataSetCache*>* managedDataSets;

/**
 Synchronization state of manager. If true, the manager is currently synchronising.
 */
@property (nonatomic, readonly) BOOL isSyncing;

/**
 Add data set to the list of managed data sets.

 @param dataSetId Data set id of the data set that should be added.
 @return The cache object if data set was successfully added as a result of this call, if the dataset already existed this method returns nil.
 */
- (nullable MPDataSetCache*) addDataSet:(NSString*)dataSetId;

/**
 Add data set to the list of managed data sets.

 @param dataSetId Data set id of the data set that should be added.
 @param scope Caching scope for this dataset.
 @return The cache object if data set was successfully added as a result of this call, if the dataset already existed this method returns nil.
*/
- (nullable MPDataSetCache*) addDataSet:(NSString*)dataSetId cachingScope: (MPDataSetCacheScope) scope;

/**
 Remove data set from the list of managed data sets. This will remove any cached content for that data set as well.
 If the dataset to be removed is the current MapsIndoors dataset, it is not removed at this time, but scheduled for deletion at a later time.
 
 @param dataSet Data set that should be removed.
 @return YES if data set was successfully removed, else NO.
 */
- (BOOL) removeDataSet:(MPDataSetCache*)dataSet;

/**
 Get the dataset-object for the given dataSetId.
 @param dataSetId dataSetId to find corresponding MPDataSetCache object for.
 @return MPDataSetCache* or nil
 */
- (nullable MPDataSetCache*) dataSetWithId:(NSString*)dataSetId;

/**
Get the dataset-object for the current MapsIndoors API key / solution
@return MPDataSetCache*
*/
- (nullable MPDataSetCache*) dataSetForCurrentMapsIndoorsAPIKey;

/**
 Set a caching strategy for given cache item.

 @param strategy Caching strategy.
 @param cacheItem Cache item.
 @return YES if strategy is set for this item, else NO.
 */
- (BOOL) setCachingStrategy:(MPDataSetCachingStrategy) strategy cacheItem: (MPDataSetCacheItem*)cacheItem;

/**
 Set a caching scope for given cache item.

 @param scope Caching scope.
 @param cacheItem Cache item.
 @return YES if strategy is changed for this item, else NO.
 */
- (BOOL) setCachingScope:(MPDataSetCacheScope)scope cacheItem: (MPDataSetCacheItem*)cacheItem;

/**
 Fetch and update content for all managed data sets. The delegate object receives the completion event.
 */
- (void) synchronizeContent;

/**
 Fetch and update content for given cache items. The delegate object receives the completion event.

 @param items The cache items to perform a synchronisation for.
 */
- (void) synchronizeCacheItems:(NSArray<MPDataSetCacheItem*>*)items;

/**
 Cancel any running synchronization of data sets.
 */
- (void) cancelSynchronization;

/**
 Cancel synchronization of data for the given cache items.
 @param items CacheItems to cancel sync of.
 */
- (void) cancelSynchronizationOfCacheItems:(NSArray<MPDataSetCacheItem*>*)items;


/**
 Determine synchronization sizes for the given set of MPDataSetCaches.
 @param dataSetCaches    MPDataSetCaches to determine sync sizes for.
 @param delegate     callback/progress receiver
 */
- (void) fetchSyncSizesForDataSetCaches:(NSArray<MPDataSetCache*>*)dataSetCaches delegate:(id<MPDataSetCacheManagerSizeDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
