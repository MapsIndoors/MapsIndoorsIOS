//
//  MPDataSetManagerDebugDelegate.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 11/02/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

@import MapsIndoors;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPDataSetManagerDebugDelegate : NSObject <MPDataSetCacheManagerDelegate>

@property (nullable, weak) id<MPDataSetCacheManagerDelegate>     wrappedDelegate;

@end

NS_ASSUME_NONNULL_END
