//
//  MPRoutingConstants.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 27/11/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPDefines.h"


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPRoutingConstants : NSObject

@property (nonatomic, readonly, class) double           walkingSpeedMetersPerSecond;
@property (nonatomic, readonly, class) NSTimeInterval   doorOpeningTime;
@property (nonatomic, readonly, class) NSTimeInterval   elevatorWaitingTime;
@property (nonatomic, readonly, class) NSTimeInterval   avoidStairsPenaltyTime;
@property (nonatomic, readonly, class) NSTimeInterval   avoidWheelChairLiftsAndRampsPenaltyTime;

/**
 Get the default travelling speed given the highwayType.

 - Parameter highwayType: highwayType to determin espeed for.
 - Returns: Travelling speed in meters per second.
 */
+ (double) speedForHighwayType:(MPHighwayType)highwayType;


@end
