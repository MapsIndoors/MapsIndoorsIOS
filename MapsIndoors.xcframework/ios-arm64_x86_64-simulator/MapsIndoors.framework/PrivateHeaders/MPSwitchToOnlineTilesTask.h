//
//  MPSwitchToOnlineTilesTask.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 25/08/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "MPDataSetCacheTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPSwitchToOnlineTilesTask : MPDataSetCacheTask

+ (instancetype) new NS_UNAVAILABLE;
+ (instancetype) newWithCacheFolder:(NSString*)cacheFolder;

- (instancetype) init NS_UNAVAILABLE;
- (instancetype) initWithCacheFolder:(NSString*)cacheFolder;

@end

NS_ASSUME_NONNULL_END
