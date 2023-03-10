//
//  MPFileCacheKeyGenerator.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 27/03/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@protocol MPFileCacheKeyGenerator <NSObject>

- (NSString*) cacheKeyFromItemid:(NSString*)itemId;

@end

NS_ASSUME_NONNULL_END
