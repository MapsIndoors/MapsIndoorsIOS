//
//  MPAvailabilityLiveUpdate.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 02/12/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "MPLiveUpdate.h"

NS_ASSUME_NONNULL_BEGIN

/// Model for live CO2 measurement for a given Location.
@interface MPCO2LiveUpdate : MPLiveUpdate

/// Get the measured CO2 level for a given Location. Base unit is Parts Per Million (PPM).
@property (nonatomic, readonly) NSMeasurement* co2Level;

@end

NS_ASSUME_NONNULL_END
