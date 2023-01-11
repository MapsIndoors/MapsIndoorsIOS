//
//  MPFileCache.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 06/03/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol MPFileCacheKeyGenerator;


NS_ASSUME_NONNULL_BEGIN

@interface MPFileCache : NSObject

@property (nonatomic, strong, class, nullable) id<MPFileCacheKeyGenerator>      cacheKeyGenerator;

@property (nonatomic, strong, readonly)        NSString*                        cacheFolder;
@property (nonatomic, readonly)                NSUInteger                       cacheSize;

// Disallow default construction:
+ (instancetype) new NS_UNAVAILABLE;
- (instancetype) init NS_UNAVAILABLE;

// Constructors with required folder:
+ (instancetype) newWithFolder:(NSString*)folder;
- (instancetype) initWithFolder:(NSString*)folder;

/**
 Return the path used for caching 'item'.
 This does not indicate that the item has cached contetn, only the path where content will reside.
 @param item item identifier.
 */
- (NSString*) pathForCachingItem:(NSString*)item;

/**
 Return the path for a cached item or nil if no data has been cached.
 @param item item identifier.
 */
- (nullable NSString*) pathForCachedItem:(NSString*)item;

/**
 Return the cached data for item or nil if no data has been cached.
 @param item item identifier.
*/
- (NSData*) cachedDataForItem:(NSString*)item;

/**
 Return the cache key for caching 'item'
 */
+ (NSString*) cacheKeyForCachingItem:(NSString*)item;

/**
 Get the path for caching 'item' in a specific cachefolder.
 Class-level version for -[pathForCachingItem:]
 @param item item id
 @param cacheFolder base folder for the cache
 */
+ (NSString* _Nullable) pathForCachingItem:(NSString*)item inFolder:(NSString*)cacheFolder;


/**
 Get the paths for cached items in a specific cachefolder and with a specific file attribute.
 @param attr endpoint attribute value
 @param cacheFolder base folder for the cache
 */
+ (NSArray<NSString*>*) pathsForCacheItemsWithApiEndpointAttr:(NSString*)attr inFolder:(NSString*)cacheFolder;

/**
 Get the path for a cached 'item' in a specific cachefolder, nil of no cached data exists.
 Class-level version for -[pathForCachedItem:]
 @param item item id
 @param cacheFolder base folder for the cache
 */
+ (nullable NSString*) pathForCachedItem:(NSString*)item inFolder:(NSString*)cacheFolder;

/**
 Store 'data' in the cache using 'item' as identifier.
 @param data data to store
 @param item item id.
 */
- (BOOL) saveData:(NSData*)data item:(NSString*)item;

/**
 Store 'data' in the cache using explicit filename (not derived from an 'item id').
 @param data data to store
 @param filename file name.
 */
- (BOOL) saveData:(NSData*)data filename:(NSString*)filename;

/**
 Return any cached data for the given 'filename', return nil if no data is cached.
 @param filename file name
 */
- (nullable NSData*) cachedDataForFilename:(NSString*)filename;

/**
 Remove any data store for the given 'item'
 */
- (void) removeDataForItem:(NSString*)item;

/**
 Remove all data in the cache, bu tleave cache folde rintact
 */
- (void) clearCache;

/**
 Remove the cache folder and all its contents.
 */
- (void) removeCacheFolder;

@end

NS_ASSUME_NONNULL_END
