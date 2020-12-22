//
//  MPOccupancyLiveUpdate.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 02/12/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "MPLiveUpdate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPOccupancyLiveUpdate : MPLiveUpdate

@property (nonatomic, readonly) int numberOfPeople;
@property (nonatomic, readonly) int capacity;

@end

NS_ASSUME_NONNULL_END
