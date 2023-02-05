//
//  NSObject+MPTileCache.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 06/03/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface NSObject (MPTileCache)

- (void) tileCache_observeTileCacheInvalidationNotifications:(SEL)aSelector;
- (void) tileCache_unobserveTileCacheInvalidationNotifications;

- (void) tileCache_postTileCacheInvalidationNotification;

@end
