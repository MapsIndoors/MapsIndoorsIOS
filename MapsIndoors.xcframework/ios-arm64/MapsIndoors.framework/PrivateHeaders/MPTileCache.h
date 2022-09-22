//
//  MPTileCache.h
//  MapsIndoorsSDK
//
//  Created by Michael Bech Hansen on 01/03/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM( NSUInteger, MPTileCacheStrategy )
{
    MPTileCacheStrategy_Unknown,
    
    MPTileCacheStrategy_Online,
    MPTileCacheStrategy_TilePackage
};


@interface MPTileCache : NSObject

@property (nonatomic) MPTileCacheStrategy               strategy;
@property (nonatomic, strong, readonly) NSString*       basePath;
@property (nonatomic, strong, readonly) NSString*       cachePath;

+ (instancetype) defaultTileCache;
+ (instancetype) createDefaultTileCacheWithStrategy:(MPTileCacheStrategy)strategy;

+ (NSString*) pathForTilePackageCacheInFolder:(NSString*)folder;
+ (NSString*) pathForOnlineTileCacheInFolder:(NSString*)folder;

+ (NSString*) cachePathForStrategy:(MPTileCacheStrategy)strategy;
+ (NSString*) pathForTilePackageCache;
+ (NSString*) pathForOnlineTileCache;

+ (instancetype) new NS_UNAVAILABLE;
- (instancetype) init NS_UNAVAILABLE;

+ (instancetype) newWithStrategy:(MPTileCacheStrategy)strategy;
- (instancetype) initWithStrategy:(MPTileCacheStrategy)strategy;

- (NSString*) cachePathForStrategy:(MPTileCacheStrategy)strategy;
- (void) setBasePath:(NSString*)baseFolder;

- (NSString*) pathForFileCachingImageForUrl:(NSString*)url;
- (UIImage*) cachedImageForUrl:(NSString*)url;
- (void) cacheImage:(UIImage*)image forUrl:(NSString*)url;

- (BOOL) shouldCheckForPreloadedTiles;
- (UIImage*) preloadedImageForUrl:(NSString*)url;

- (BOOL) shouldCheckForOnlineTiles;

- (void) flushTilePackageCache;
- (void) flushOnlineTileCache;

- (void) tilePackageCacheWasUpdated:(NSString*)folder;
- (void) tilePackageCacheWasRemoved:(NSString*)folder;

@end
