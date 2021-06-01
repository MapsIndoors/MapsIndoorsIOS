//
//  MPDataSetCacheItem.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 03/02/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPDataSetEnums.h"
#import "MPSolution.h"

NS_ASSUME_NONNULL_BEGIN


/**
Data set cache item class.
*/
@interface MPDataSetCacheItem : NSObject

/**
 Initialise a data set cache item with an id.
 @param itemId Item id.
*/
- (instancetype)initWithId:(NSString*)itemId;

/**
Cache item id.
*/
@property (nonatomic, readonly, strong) NSString* cachingItemId;

/**
Cache item name.
*/
@property (nonatomic, readonly, strong, nullable) NSString* name;

/**
Cache item content language.
*/
@property (nonatomic, readonly, strong, nullable) NSString* language;

/**
Caching strategy for this cache item.
*/
@property (nonatomic, readonly) MPDataSetCachingStrategy cachingStrategy;

/**
Cache scope for this cache item.
*/
@property (nonatomic, readonly) MPDataSetCacheScope cachingScope;

/**
Cache state. If true, content is cached for this cache item.
*/
@property (nonatomic, readonly) BOOL isCached;

/**
If true, content is going to be synchronised.
*/
//@property (nonatomic, readonly) BOOL isScheduledForSync;

/**
Synchronisation state. If true, content is currently being synchronised for this cache item.
*/
@property (nonatomic, readonly) BOOL isSyncing;

/**
 Date of last successfull caching performed for this cache item.
 */
@property (nonatomic, readonly, strong, nullable) NSDate* cachedTimestamp;

/**
 Disk size in bytes for the currently cached content of this cache item.
 */
@property (nonatomic, readonly) NSUInteger cachedSize;

/**
 Date of last content synchronisation performed for this cache item.
 Note this does not indicate success or failure, just that a synchronization finished at a certain point in time.
*/
@property (nonatomic, readonly, strong, nullable) NSDate* syncTimestamp;

/**
Latest synchronisation result as an error object. If nil, either no synchronisation has been performed or latest synchronisation was successful.
*/
@property (nonatomic, readonly, strong, nullable) NSError* syncResult;

/**
Estimated possible synchronization size, if no content has been synchronised yet for this cache item.
*/
@property (nonatomic, readonly) NSUInteger syncSize;

@end

NS_ASSUME_NONNULL_END
