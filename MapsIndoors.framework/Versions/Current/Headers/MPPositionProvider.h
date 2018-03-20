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

/**
 Protocol specifying how an indoor positioning provider delegate should be implemented as the receiver of user positions.
 */
@protocol MPPositionProviderDelegate <NSObject>

@required

/**
 Position update method. Will return a position result.

 @param positionResult The position result as estimated or calculated by a MPPositionProvider
 */
- (void)onPositionUpdate:(MPPositionResult*)positionResult;

/**
 Positioning fail method. Will return the reference to the actual provider

 @param provider A provider that failed determining user position
 */
- (void)onPositionFailed:(id)provider;
@end


/**
 Protocol specifying how an indoor positioning provider should be implemented if the users location is to be exposed to MPMapControl
 */
@protocol MPPositionProvider <NSObject>

/**
 Set location services flag that determines if app should request location always or only when in use
 */
@property (nonatomic) BOOL                              preferAlwaysLocationPermission;

/**
 Get location services activity status
 */
@property (nonatomic, readonly) BOOL                    locationServicesActive;     // enabled AND authorized

/**
 Request location services permissions
 */
- (void) requestLocationPermissions;
/**
 Update location services permission status
 */
- (void) updateLocationPermissionStatus;


/**
 Start the provider. The argument value is depending on the implementation.

 @param arg The argument value is depending on the implementation
 */
- (void)startPositioning:(NSString*)arg;
/**
 Stop the provider. The argument value is depending on the implementation.
 
 @param arg The argument value is depending on the implementation
 */
- (void)stopPositioning:(NSString*)arg;
/**
 Start the provider after specified number of milliseconds. The argument value is depending on the implementation.
 
 @param millis The number of milliseconds before the provider will start
 @param arg The argument value is depending on the implementation
 */
- (void)startPositioningAfter:(int)millis arg:(NSString*)arg;

/**
 The running state of the provider

 @return The running state. YES means the provider is running.
 */
- (BOOL)isRunning;

/**
 Delegate object. The receiver of user positions.
 */
@property (weak) id<MPPositionProviderDelegate> delegate;

/**
 Latest position result if any.
 */
@property MPPositionResult* latestPositionResult;

/**
 Provider type stored as an integer. Currently not used by MPMapControl.
 */
@property MPPositionProviderType providerType;

@end

