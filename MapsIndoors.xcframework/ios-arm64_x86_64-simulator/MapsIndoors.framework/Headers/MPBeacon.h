//
//  MPBeacon.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 26/02/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPPoint.h"
#import "JSONModel.h"


@protocol MPBeacon
@end


@interface MPBeacon : JSONModel

@property (nonatomic, strong, nullable) NSString* beaconId;
@property (nonatomic, strong, nullable) NSNumber* maxTxPower;
@property (nonatomic, strong, nullable) NSNumber* maxTxDistance;
@property (nonatomic, strong, nullable) NSNumber* floor;
@property (nonatomic, strong, nullable) NSString* building;
@property (nonatomic, strong, nullable) NSString* venue;
@property (nonatomic, strong, nullable) NSMutableArray<Optional> *RSSI;
@property (nonatomic, strong, nullable) NSDate<Optional> *latestTimeStamp;

@property (nonatomic, strong, nullable) MPPoint* geometry;

@end

