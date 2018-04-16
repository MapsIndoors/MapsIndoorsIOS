//
//  PositionCalculator.h
//  MIAIOS
//
//  Created by Martin Hansen on 5/19/15.
//  Copyright (c) 2015-2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapsIndoors/MapsIndoors.h>

@interface MPPositionCalculator : NSObject

+ (double)convertRSSItoMeter:(double) RSSI A:(double) A;
//Returns the position based on trilateration on the given measurements given a reference point of (0,0).
// Note: The error margin is given as z.
- (MPPoint*)calcLatLngPos:(NSArray *)measurements;

@end
