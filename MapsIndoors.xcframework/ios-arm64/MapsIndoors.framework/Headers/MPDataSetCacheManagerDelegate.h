//
//  MPDataSetManagerDelegate.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 31/01/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


@class MPDataSetCache;
@class MPDataSetCacheItem;
@class MPDataSetCacheManager;

/**
Data set manager delegate protocol.
*/
@protocol MPDataSetCacheManagerDelegate <NSObject>

/**
 Called when a data set is added to a data set manager.
 @param dataSetManager Originator of the callback
 @param dataset Data set that was added.
*/
@optional
- (void) dataSetManager:(MPDataSetCacheManager*)dataSetManager didAddDataSet: (MPDataSetCache*) dataset;

/**
 Called when a data set is removed from a data set manager.
 @param dataSetManager Originator of the callback
 @param dataset Data set that was removed.
*/
@optional
- (void) dataSetManager:(MPDataSetCacheManager*)dataSetManager didRemoveDataSet: (MPDataSetCache*) dataset;


/**
 Called when the data set manager starts to synchronize one or more datasets.
 @param dataSetManager Originator of the callback
*/
@optional
- (void) dataSetManagerWillStartSynchronizing:(MPDataSetCacheManager*)dataSetManager;

/**
 Called when the data set manager starts to synchronize one or more datasets.
 @param dataSetManager Originator of the callback
*/
@optional
- (void) dataSetManagerDidFinishSynchronizing:(MPDataSetCacheManager*)dataSetManager;

/**
 Called when a data set is scheduled for synchronization by the dataset manager.
 @param dataSetManager Originator of the callback
 @param dataset Data set that was scheduled for synchronization.
*/
@optional
- (void) dataSetManager:(MPDataSetCacheManager*)dataSetManager willStartSynchronizingDataSet:(MPDataSetCache*)dataset;

/**
 Called when a data set has finished synchronization.
 @param dataSetManager Originator of the callback
 @param dataset Data set that was scheduled for synchronization.
*/
@optional
- (void) dataSetManager:(MPDataSetCacheManager*)dataSetManager didFinishSynchronizingDataSet:(MPDataSetCache*)dataset;

///**
// Called when a cache item batch synchronisation is started.
// @param items Items that will be synchronised.
//*/
//@optional
//- (void) dataSetManager:(MPDataSetCacheManager*)dataSetManager willStartSynchronizingItems: (NSArray<MPDataSetCacheItem*>*) items;
//
///**
// Called when a cache item batch synchronisation is finished.
// @param items Items that was synchronised.
//*/
//@optional
//- (void) dataSetManager:(MPDataSetCacheManager*)dataSetManager didFinishSynchronizingItems: (NSArray<MPDataSetCacheItem*>*) items;

/**
 Called when a cache item synchronisation is started.
 @param dataSetManager Originator of the callback
 @param item Item that will be synchronised.
*/
@optional
- (void) dataSetManager:(MPDataSetCacheManager*)dataSetManager willStartSynchronizingItem: (MPDataSetCacheItem*) item;

/**
 Called when a cache item synchronisation is finished.
 @param dataSetManager Originator of the callback
 @param item Item that was synchronised.
*/
@optional
- (void) dataSetManager:(MPDataSetCacheManager*)dataSetManager didFinishSynchronizingItem: (MPDataSetCacheItem*) item;

@end

NS_ASSUME_NONNULL_END
