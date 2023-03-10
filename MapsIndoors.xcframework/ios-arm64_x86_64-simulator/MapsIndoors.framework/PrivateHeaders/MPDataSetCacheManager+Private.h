//
//  NSObject+MPDataSetCacheHelper.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 10/02/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "MPDataSetCacheManager.h"
#import "MPMapsIndoors.h"


NS_ASSUME_NONNULL_BEGIN


typedef void (^mpCachedDataCompletion)(NSData * _Nullable, NSError* _Nullable);

@interface MPDataSetCacheManager(Private)

- (NSString*) pathForCachingDataSetId:(NSString*)dataSetId;
- (NSString*) pathForCachingUrl:(NSURL*)url dataSetId:(NSString*)dataSetId;
- (NSString*) pathForCachedUrl:(NSURL*)url dataSetId:(NSString*)dataSetId;
- (NSData*) dataForCachedUrl:(NSURL*)url dataSetId:(NSString*)dataSetId;

- (void) synchronizeContent:(nullable mpSyncContentHandlerBlockType)completionHandler;
- (void) synchronizeCurrentDataSetContent:(nullable mpSyncContentHandlerBlockType)completionHandler;

/**
Fetch sizes for given cache items. The sizes retrieved is estimated sizes, not real disk sizes. The delegate object receives the result.

@param cacheItems The cache items to fetch sizes for.
*/
- (void) fetchSyncSizesForCacheItems: (NSArray<MPDataSetCacheItem*>*) cacheItems;

/**
 Mark the timestamp that the dataset with id wase being activated.
 @param dataSetId dataSetId
 */
- (void) registerActiveDataSetId:(NSString*)dataSetId;

/**
 Remove datasets that has not been used for at least 'minTimeSinceLastUse'.
 This only removes datasets with strategy = MPDataSetCachingStrategyDontCache.
 @param minTimeSinceLastUse At least this much time mast have passed since the datset was last active.
 */
- (void) removeDataSetsInactiveForMoreThan:(NSTimeInterval)minTimeSinceLastUse;

- (nullable MPDataSetCache*) iAddDataSet:(NSString*)dataSetId cachingScope: (MPDataSetCacheScope) scope;
- (BOOL) iRemoveDataSet:(MPDataSetCache*)dataSet;

@end


@interface MPDataSetCacheManager ()

/**
Get a shared instance of a data set manager.

@return Shared instance of a data set manager.
*/
+ (MPDataSetCacheManager*) sharedInstance;

@end

NS_ASSUME_NONNULL_END
