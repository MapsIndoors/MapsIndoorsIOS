//
//  PointXY.h
//  MapsIndoorSDK
//
//  Created by Martin Hansen on 5/21/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//
#import "MPLocation.h"

@interface PointXY : MPLocation

@property (nonatomic) double X;
@property (nonatomic) double Y;
@property (nonatomic) double distance;
@property (nonatomic) CLLocationCoordinate2D latlng;

+ (CLLocationCoordinate2D) getRefPoint;
@end

//Sets an arbitrary reference point at the first given beacon
//ANY reference position could be used - but using a ref point close to the measurement point yields better accuracy.
static CLLocationCoordinate2D refPoint;
static bool isRefSet = NO;
