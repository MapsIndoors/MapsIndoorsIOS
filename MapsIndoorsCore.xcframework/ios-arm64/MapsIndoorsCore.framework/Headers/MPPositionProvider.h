//
//  MPPositionProvider.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 10/03/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPPositionResult.h"

typedef NS_ENUM(NSUInteger, MPPositionProviderType) {
    GPS_POSITION_PROVIDER = 0,
    MOBILE_NETWORK_POSITION_PROVIDER = 1,
    COMBINED_POSITION_PROVIDER = 2,
    WIFI_POSITION_PROVIDER = 3,
    SENSOR_BASED_POSITION_PROVIDER = 4
};

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Protocol specifying how an indoor positioning provider delegate should be implemented as the receiver of user positions.
 */
@protocol MPPositionProviderDelegate <NSObject>

@required

/**
 Position update method. Will return a position result.

 - Parameter positionResult: The position result as estimated or calculated by a MPPositionProvider
 */
- (void)onPositionUpdate:(nonnull MPPositionResult*)positionResult;

/**
 Positioning fail method. Will return the reference to the actual provider

 - Parameter provider: A provider that failed determining user position
 */
- (void)onPositionFailed:(nonnull id)provider;
@end

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Protocol specifying how an indoor positioning provider should be implemented if the users location is to be exposed to MPMapControl
 */
@protocol MPPositionProvider <NSObject>


/**
 Delegate object. The receiver of user positions.
 */
@property (nonatomic, weak, nullable) id<MPPositionProviderDelegate> delegate;

/**
 Latest position result if any.
 */
@property (nonatomic, strong, nullable) MPPositionResult* latestPositionResult;

@end

