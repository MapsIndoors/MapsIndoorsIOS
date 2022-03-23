//
//  MPDataSetManagerDebugDelegate.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 11/02/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "MPDataSetCacheManagerDelegate.h"


NS_ASSUME_NONNULL_BEGIN

@interface MPDataSetManagerDebugDelegate : NSObject <MPDataSetCacheManagerDelegate>

@property (nullable, weak) id<MPDataSetCacheManagerDelegate>     wrappedDelegate;

@end

NS_ASSUME_NONNULL_END
