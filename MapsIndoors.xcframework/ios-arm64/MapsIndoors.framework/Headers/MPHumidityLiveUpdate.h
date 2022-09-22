//
//  MPHumidityLiveUpdate.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 28/05/2021.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "MPLiveUpdate.h"

NS_ASSUME_NONNULL_BEGIN

/// Model for live humidity measurement for a given Location.
@interface MPHumidityLiveUpdate : MPLiveUpdate

/// Get the measured relative humidity for a given Location. 
@property (nonatomic, readonly) NSMeasurement* relativeHumidity;

@end

NS_ASSUME_NONNULL_END
