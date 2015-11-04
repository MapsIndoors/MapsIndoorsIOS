//
//  BeaconPositionProvider.h
//  BellaCenter
//
//  Created by Pelle Ravn on 18/02/15.
//  Copyright (c) 2015 Huge Lawn - Miracle Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "MPPositionProvider.h"
#import "MPBeaconProvider.h"
#import "MPBeacon.h"

@interface MPBeaconPositionProvider : NSObject<MPPositionProvider, CLLocationManagerDelegate, MPBeaconProviderDelegate>

- (id)initWithUUID:(NSString*)UUID;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (assign, nonatomic) BOOL isRunning;
@property (strong, nonatomic) CLBeaconRegion *beaconRegion;
@property (strong, nonatomic) NSMutableDictionary *beaconPoints;
@property (strong, nonatomic) NSMutableArray *deadBeaconPoints;
@property (strong, nonatomic) MPBeaconProvider* beaconProvider;
@property (assign, nonatomic) double heading;
@property (assign, nonatomic) double lastBeaconRecievedTime;
@property (nonatomic, retain) MPPoint *pos;
@property (assign, nonatomic) double probability;
@property (assign, nonatomic) NSString* debugPositioningState NS_DEPRECATED_IOS(8_0, 9_0);
@property (assign, nonatomic) NSArray* debugCurrentVisibleBeacons NS_DEPRECATED_IOS(8_0, 9_0);
@property (assign, nonatomic) MPBeacon* currentNearestBeacon;


@end
