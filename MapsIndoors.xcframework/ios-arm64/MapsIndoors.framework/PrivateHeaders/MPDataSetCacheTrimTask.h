//
//  MPDataSetCacheTrimTask.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 17/08/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "MPDataSetCacheTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPDataSetCacheTrimTask : MPDataSetCacheTask

+ (instancetype) new NS_UNAVAILABLE;
- (instancetype) init NS_UNAVAILABLE;

+ (instancetype) newWithDeletions:(NSArray<NSString*>*)paths;
- (instancetype) initWithDeletions:(NSArray<NSString*>*)paths;

@end

NS_ASSUME_NONNULL_END
