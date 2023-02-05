//
//  MPAvailabilityLiveUpdate.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 02/12/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "MPLiveUpdate.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// Model for live availability information for a given Location.
/// > Warning: [INTERNAL - DO NOT USE]
@interface MPAvailabilityLiveUpdate : MPLiveUpdate

/// Get the availability state for a given Location.
@property (nonatomic, readonly) BOOL available;

@end

NS_ASSUME_NONNULL_END
