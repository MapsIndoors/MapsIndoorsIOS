//
//  PositionCalculator.h
//  MapsIndoorSDK
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
@import JSONModel;
#import "PointXY.h"
#import "MPLatLng.h"

@interface PositionCalculator : NSObject

+ (double)convertRSSItoMeter:(double) RSSI A:(double) A;

- (MPPoint*)calcLatLngPos:(NSArray *)measurements;

@end
