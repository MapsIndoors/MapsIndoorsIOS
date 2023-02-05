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

#pragma mark - [INTERNAL - DO NOT USE]

/// Model for live position information for a given Location.
/// > Warning: [INTERNAL - DO NOT USE]
@interface MPPositionLiveUpdate : MPLiveUpdate

/// Get the geographic coordinates.
@property (nonatomic, readonly) CLLocationCoordinate2D position;
/// Get the floor index.
@property (nonatomic, readonly) int floorIndex;

@end

NS_ASSUME_NONNULL_END
