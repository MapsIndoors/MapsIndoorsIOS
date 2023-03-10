//
//  MPLiveDomainType.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 05/08/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Constant for Occupancy Domain Type
#define kMPLiveDomainTypeOccupancy @"occupancy"
/// Constant for Position Domain Type
#define kMPLiveDomainTypePosition @"position"
/// Constant for Availability Domain Type
#define kMPLiveDomainTypeAvailability @"availability"
/// Constant for Count Domain Type
#define kMPLiveDomainTypeCount @"count"
/// Constant for Temperature Domain Type
#define kMPLiveDomainTypeTemperature @"temperature"
/// Constant for CO2 Domain Type
#define kMPLiveDomainTypeCO2 @"co2"
/// Constant for Humidity Domain Type
#define kMPLiveDomainTypeHumidity @"humidity"

NS_ASSUME_NONNULL_BEGIN

/// Convenience class for static Live Domain Types
@interface MPLiveDomainType : NSObject
/// Get the Occupancy Domain Type
@property (class, readonly, nonatomic, strong) NSString* occupancy;
/// Get the Position Domain Type
@property (class, readonly, nonatomic, strong) NSString* position;
/// Get the Availability Domain Type
@property (class, readonly, nonatomic, strong) NSString* availability;
/// Get the Count Domain Type
@property (class, readonly, nonatomic, strong) NSString* count;
/// Get the Temperature Domain Type
@property (class, readonly, nonatomic, strong) NSString* temperature;
/// Get the CO2 Domain Type
@property (class, readonly, nonatomic, strong) NSString* co2;
/// Get the Humidity Domain Type
@property (class, readonly, nonatomic, strong) NSString* humidity;

@end

NS_ASSUME_NONNULL_END
