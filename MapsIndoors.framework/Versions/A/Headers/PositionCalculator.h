//
//  PositionCalculator.h
//  MapsIndoors
//
//  Created by Martin Hansen on 5/19/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPPoint.h"
#import <UIKit/UIKit.h>

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MPLocationDisplayRule.h"
#import <JSONModel/JSONModel.h>
#import "PointXY.h"
#import "MPLatLng.h"

@interface PositionCalculator : NSObject

+ (double)convertRSSItoMeter:(double) RSSI A:(double) A;
//Returns the position based on trilateration on the given measurements given a reference point of (0,0).
// Note: The error margin is given as z.
- (MPPoint*)calcLatLngPos:(NSArray *)measurements;

@end
