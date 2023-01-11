//
//  MPMapFilter.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 13/08/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPMapBehavior.h"

NS_ASSUME_NONNULL_BEGIN

// Filter behavior class that determines how a filter should be display on the map. Get the default behavior from `MPFilterBehavior.default`. The default behavior is no camera movement and no infowindow shown.
@interface MPFilterBehavior : NSObject<MPMapBehavior>

// Default filter behavior
@property (nonatomic, class, readonly) MPFilterBehavior* defaultBehavior;

// Whether `MPMapControl` should move the camera and fit the map view to the filtered locations. The default behavior is no camera movement (NO).
@property (nonatomic) BOOL moveCamera;

// Whether `MPMapControl` should show the info window if a filter only contains one Location. The default behavior is no infowindow shown (NO).
@property (nonatomic) BOOL showInfoWindow;

@end

NS_ASSUME_NONNULL_END
