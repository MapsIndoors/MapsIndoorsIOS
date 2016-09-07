//
//  MPBeaconProvider.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 26/02/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Beacons provider delegate.
 */
@protocol MPBeaconProviderDelegate <NSObject>
/**
 * Beacons data ready event method.
 * @param BeaconsCollection The Beacons data collection.
 */
@required
- (void) onBeaconsReady: (NSArray*)beaconData;

@end

/**
 * Beacons provider protocol.
 */
@protocol MPBeaconProvider <NSObject>

@property (weak) id <MPBeaconProviderDelegate> delegate;
/**
 * Method to initiate fetching of Beacons from the provider.
 */
@required
- (void)getBeacons: (NSArray*) beaconIds clientId: (NSString*) clientId;

@end

/**
 * Beacons provider that defines a delegate and a method to initiate fetching of Beacons from the provider.
 */
@interface MPBeaconProvider : NSObject<MPBeaconProvider>
/**
 * Beacons provider delegate.
 */
@property (weak) id <MPBeaconProviderDelegate> delegate;

/**
 * Method to initiate fetching of Beacons from the provider.
 */
- (void)getBeacons: (NSArray*) beaconIds clientId: (NSString*) clientId;
/**
 * Method to query a subset of Beacons from the provider.
 */

- (id)init;


@end

