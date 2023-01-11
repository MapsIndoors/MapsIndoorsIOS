//
//  MPDataSetCacheManagerSizeDelegate.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 09/03/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MPDataSetCacheManager;
@class MPDataSetCache;


NS_ASSUME_NONNULL_BEGIN

/// Delegate protocol for getting callbacks when determining the size af dataset syncs.
@protocol MPDataSetCacheManagerSizeDelegate <NSObject>

/// Called when the DataSetManager starts determing sync sizes for its managed datasets.
/// @param dsm MPDataSEtManager
@optional
- (void) dataSetManagerWillStartFetchingSyncSizes:(MPDataSetCacheManager*)dsm;

/// Called to indicate the start of fetching sync size for a single dataset.
/// @param dsm MPDataSEtManager
/// @param dataSet The dataset for which sync size is being determined.
@optional
- (void) dataSetManager:(MPDataSetCacheManager*)dsm willStartFetchingSyncSizesForDataSet:(MPDataSetCache*)dataSet;

@optional
/// Called to indicate the fnish of fetching sync size for a single dataset.
/// @param dsm MPDataSEtManager
/// @param dataSet The dataset for which sync size is being determined.
- (void) dataSetManager:(MPDataSetCacheManager*)dsm didFetchSyncSizesForDataSet:(MPDataSetCache*)dataSet;

@optional
/// Called to indicate that the DataSetManager has finished determining sync sizes for all managed datasets..
/// @param dsm MPDataSEtManager
- (void) dataSetManagerDidFinishFetchingSyncSizes:(MPDataSetCacheManager*)dsm;

@end

NS_ASSUME_NONNULL_END
