//
//  MPTemperatureLiveUpdate.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 02/12/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "MPLiveUpdateInternal.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// Model for live temperature measurement for a given Location.
/// > Warning: [INTERNAL - DO NOT USE]
@interface MPTemperatureLiveUpdate : MPLiveUpdateInternal

/// Get the measured temperature for a given Location. Base unit is Kelvin.
@property (nonatomic, readonly) NSMeasurement* temperature;

@end

NS_ASSUME_NONNULL_END
