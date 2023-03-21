//
//  MPCountLiveUpdate.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 02/12/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "MPLiveUpdateInternal.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// Model for live event information for a given Location.
/// > Warning: [INTERNAL - DO NOT USE]
@interface MPCountLiveUpdate : MPLiveUpdateInternal

/// Get the the number of times an arbitrary event has been fired for a given Location.
@property (nonatomic, readonly) int count;

@end

NS_ASSUME_NONNULL_END
