//
//  MPBeacon.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 26/02/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPPoint.h"
#import "MPJSONModel.h"

@interface MPBeacon : MPJSONModel

@property NSString* beaconId;
@property NSNumber* maxTxPower;
@property NSNumber* maxTxDistance;
@property NSNumber* floor;
@property NSString* building;
@property NSString* venue;
@property NSMutableArray<Optional> *RSSI;
@property NSDate<Optional> *latestTimeStamp;

@property MPPoint* geometry;

@end

