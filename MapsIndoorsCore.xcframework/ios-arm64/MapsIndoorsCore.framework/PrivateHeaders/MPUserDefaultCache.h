//
//  MPStringCache.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 29/01/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPUserDefaultCache : NSObject

+ (void)setString:(NSString *)string intoCache: (NSString *)cacheKey;
+ (NSString * _Nullable)getStringFromCache:(NSString *)cacheKey;
+ (void) clearCache;

@end

NS_ASSUME_NONNULL_END
