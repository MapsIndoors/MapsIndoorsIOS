//
//  MPDataSetCacheItem+Private.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 04/02/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "MPDataSetCacheItem.h"


@class MPDataSetCache;
@class MPDataSetCacheTask;
@class MPUrlResourceGroup;
@class MPFileCache;
@protocol MPDataSetCacheItemDelegate;


NS_ASSUME_NONNULL_BEGIN

@interface MPDataSetCacheItem (Private)

- (instancetype) initWithDictionary:(NSDictionary*)dict;
- (NSDictionary*) asDictionary;

@property (nonatomic, weak)              MPDataSetCache*                    owner;
@property (nonatomic, strong, readwrite) MPFileCache*                       cache;
@property (nonatomic, weak)              id<MPDataSetCacheItemDelegate>     delegate;

@property (nonatomic, readwrite)         MPDataSetCachingStrategy           cachingStrategy;
@property (nonatomic, readwrite)         MPDataSetCacheScope                cachingScope;
@property (nonatomic, readwrite)         BOOL                               isScheduledForSync;
@property (nonatomic, readwrite)         NSUInteger                         syncSize;
@property (nonatomic, readwrite, strong) NSString*                          name;
@property (nonatomic, readwrite, strong) NSString*                          language;
@property (nonatomic, readwrite)         BOOL                               isCached;
@property (nonatomic, readwrite)         BOOL                               isSyncing;
@property (nonatomic, readwrite, strong) NSDate*                            cachedTimestamp;
@property (nonatomic, readwrite)         NSUInteger                         cachedSize;
@property (nonatomic, readwrite, strong) NSDate*                            syncTimestamp;
@property (nonatomic, readwrite, strong) NSError*                           syncResult;

- (void) addSyncResult:(NSError *)syncResult forUrl:(nullable NSURL*)url;

- (void) setSyncResources:(NSArray<MPUrlResourceGroup*>*)syncResources withPriorities:(NSArray<NSNumber*>*)priorities;


/// Get the tasks needed for syncing this item.
/// The first task in the array is executed first, the last task in the array is executed last.
/// All in-between tasks, if any, are executed in a non-specific/deterministic order.
- (NSArray<MPDataSetCacheTask*>*) getTasksForCaching;

@end


@protocol MPDataSetCacheItemDelegate <NSObject>

@required
- (void) syncStarted:(MPDataSetCacheItem*)item;

@required
- (void) syncFinished:(MPDataSetCacheItem*)item;

@end

NS_ASSUME_NONNULL_END
