//
//  BeaconPositionProvider.h
//  BellaCenter
//
//  Created by Martin Hansen on 18/02/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapsIndoors/MapsIndoors.h>

@interface BeaconPositionProvider : NSObject<MPPositionProvider, CLLocationManagerDelegate, MPBeaconProviderDelegate>

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
@property (nonatomic) NSNumber* floor;


@end
