//
//  MPAppMode.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 9/18/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Provides a static way to access the possible app modes
 */
@interface MPAppMode : NSObject
/**
 Indoor app mode (equals 0)
 */
+ (int)INDOOR;
/**
 Outdoor app mode (equals 1)
 */
+ (int)OUTDOOR;
/**
 Indoor and outdoor app mode (equals 2)
 */
+ (int)INDOOR_AND_OUTDOOR;

@end
