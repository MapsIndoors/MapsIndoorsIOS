//
//  MPMemoryCache.h
//  MapsIndoors App
//
//  Created by Daniel Nielsen on 17/06/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPMemoryCache : NSObject

- (void) setObject:(NSObject*)object forKey:(NSString*) key;
- (NSObject* _Nullable) objectForKey:(NSString*) key;
- (void) removeObjectForKey:(NSString*) key;

- (NSString* _Nullable) cacheKeyForUrl:(NSString* _Nullable)sUrl;

@end

NS_ASSUME_NONNULL_END
