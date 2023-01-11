//
//  MapProviderDelegate.h
//  MapsIndoorsSDK
//
//  Created by Christian Wolf Johannsen on 13/04/2022.
//  Copyright © 2022 MapsPeople A/S. All rights reserved.
//

#ifndef MapProviderDelegate_h
#define MapProviderDelegate_h

#import "MapsIndoorsCore/MapsIndoorsCore-Swift.h"

@class MPMapControl;

@interface MapProviderDelegate: NSObject<MPMapProviderDelegate>

NS_ASSUME_NONNULL_BEGIN

@property (nonatomic, strong) MPMapControl* mapControl;
@property (nonatomic) BOOL didRunFirstMapIdle;
@property (nonatomic) BOOL userGestureInProgress;
//@property (nonatomic, strong) GMSMapView* map;
@property (nonatomic, strong) MPSelectionBehavior*  currentSelectionBehavior;
@property (nonatomic, weak, nullable) id<MPMapControlDelegate> delegate;
@property (nonatomic, nullable) NSString* venue;
@property (nonatomic) NSArray<MPVenue*>*    venueCollection;

NS_ASSUME_NONNULL_END

@end

#endif /* MapProviderDelegate_h */
