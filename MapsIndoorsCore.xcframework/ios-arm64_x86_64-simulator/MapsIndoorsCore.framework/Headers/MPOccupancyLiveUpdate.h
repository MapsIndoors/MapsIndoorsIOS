//
//  MPOccupancyLiveUpdate.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 02/12/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "MPLiveUpdate.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// Model for live occupancy information for a given Location.
/// > Warning: [INTERNAL - DO NOT USE]
@interface MPOccupancyLiveUpdate : MPLiveUpdate

/// Get the number of people measured for a given Location.
@property (nonatomic, readonly) int numberOfPeople;
/// Get the current capacity in terms of maximum number of people for a given Location.
@property (nonatomic, readonly) int capacity;

@end

NS_ASSUME_NONNULL_END
