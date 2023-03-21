//
//  MPHumidityLiveUpdate.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 28/05/2021.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "MPLiveUpdateInternal.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// Model for live humidity measurement for a given Location.
/// > Warning: [INTERNAL - DO NOT USE]
@interface MPHumidityLiveUpdate : MPLiveUpdateInternal

/// Get the measured relative humidity for a given Location. 
@property (nonatomic, readonly) NSMeasurement* relativeHumidity;

@end

NS_ASSUME_NONNULL_END
