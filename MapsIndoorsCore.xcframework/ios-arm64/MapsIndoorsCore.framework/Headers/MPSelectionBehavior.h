//
//  MPSelectionBehavior.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 24/08/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPMapBehavior.h"

NS_ASSUME_NONNULL_BEGIN

// Selection behavior class that determines how a location selection should be displayed on the map. Get the default behavior from `MPSelectionBehavior.default`. The default behavior is that the camera moves to display the selected location and the infowindow is shown.
@interface MPSelectionBehavior : NSObject<MPMapBehavior>

// Default selection behavior
@property (nonatomic, class, readonly) MPSelectionBehavior* defaultBehavior;

// Whether `MPMapControl` should move the camera and fit the map view to show the selected location. The default value is YES.
@property (nonatomic) BOOL moveCamera;

// Whether `MPMapControl` should show the info window if a filter only contains one Location. The default behavior is no infowindow shown YES.
@property (nonatomic) BOOL showInfoWindow;

@end

NS_ASSUME_NONNULL_END
