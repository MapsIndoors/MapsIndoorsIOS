//
//  MPPositionLiveUpdate.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 02/12/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "MPLiveUpdate.h"
#import <CoreLocation/CoreLocation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPPositionLiveUpdate : MPLiveUpdate

@property (nonatomic, readonly) CLLocationCoordinate2D position;
@property (nonatomic, readonly) int floor;

@end

NS_ASSUME_NONNULL_END
