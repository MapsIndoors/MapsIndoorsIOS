//
//  MPDataSetCache+Private.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 06/02/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPDataSetCacheInternal.h"

@class MPFileCache;
@class MPDataSetCacheTask;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPDataSetCacheInternal (Private)

- (instancetype) initWithId:(NSString*)dataSetId cache:(MPFileCache*)cache;
//- (instancetype) initWithDictionary:(NSDictionary*)dict;

///This is necessary as long as we can use API keys to build dataset caches
@property (nonatomic, strong, readwrite) NSString*                       realDatasetId;

- (BOOL) saveToDisk;
- (NSDictionary*) asDictionary;

@end

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPDataSetCacheInternal ()

@property (nonatomic, strong) NSDate*                           lastUsedTime;   /// Time the dataset was last referenced in [MapsIndoors provideApiKey:

@property (nonatomic, readwrite) MPDataSetCachingStrategy       cachingStrategy;

@property (nonatomic, strong, readwrite) MPFileCache*           cache;
@property (nonatomic, strong, readwrite) MPDataSetCacheTask*    taskForScopingDataSetSize;


- (MPDataSetCacheTask*) getOrCreateTaskForScopingDataSetSize;
- (BOOL) hasScopedDataSetSize;

- (BOOL) setCachingScope:(MPDataSetCachingScope)scope cacheItem:(id<MPDataSetCacheItem>)cacheItem;

@end

NS_ASSUME_NONNULL_END
