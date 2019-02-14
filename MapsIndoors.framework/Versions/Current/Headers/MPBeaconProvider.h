//
//  MPBeaconProvider.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 26/02/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPDefines.h"


/**
 Beacons provider delegate.
 */
@protocol MPBeaconProviderDelegate <NSObject>
/**
 Beacons data ready event method.
 @param  BeaconsCollection The Beacons data collection.
 */
@required
- (void) onBeaconsReady: (nonnull NSArray*)beaconData;

@end

/**
 Beacons provider protocol.
 */
@protocol MPBeaconProvider <NSObject>

@property (nonatomic, weak, nullable) id <MPBeaconProviderDelegate> delegate;

/**
 Method to initiate fetching of Beacons from the provider.
 */
@required
- (void)getBeacons: (nonnull NSArray*) beaconIds clientId: (nonnull NSString*) clientId;

@required
- (void)getBeacons: (nonnull NSString*) solutionId;

@end

/**
 Beacons provider that defines a delegate and a method to initiate fetching of Beacons from the provider.
 */
@interface MPBeaconProvider : NSObject<MPBeaconProvider>
/**
 Beacons provider delegate.
 */
@property (nonatomic, weak, nullable) id <MPBeaconProviderDelegate> delegate;

/**
 Method to initiate fetching of Beacons from the provider.
 @deprecated
 */
- (void)getBeacons: (nonnull NSArray*) beaconIds clientId: (nonnull NSString*) clientId MP_DEPRECATED_MSG_ATTRIBUTE("Use -(void)getBeacons:(NSString*)solutionId instead");
/**
 Method to initiate fetching of Beacons from the provider.
 */
- (void)getBeacons: (nonnull NSString*) solutionId;

- (nonnull instancetype)init;


@end

