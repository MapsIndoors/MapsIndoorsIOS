//
//  MPAvailabilityLiveUpdate.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 02/12/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "MPLiveUpdateInternal.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// Model for live CO2 measurement for a given Location.
/// > Warning: [INTERNAL - DO NOT USE]
@interface MPCO2LiveUpdate : MPLiveUpdateInternal

/// Get the measured CO2 level for a given Location. Base unit is Parts Per Million (PPM).
@property (nonatomic, readonly) NSMeasurement* co2Level;

@end

NS_ASSUME_NONNULL_END
