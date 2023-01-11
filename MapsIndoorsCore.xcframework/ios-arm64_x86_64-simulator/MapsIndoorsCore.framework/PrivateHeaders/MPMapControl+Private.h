//
//  MPMapControl+Private.h
//  MapsIndoorsSDK
//
//  Created by Christian Wolf Johannsen on 13/04/2022.
//  Copyright © 2022 MapsPeople A/S. All rights reserved.
//

#ifndef MPMapControl_Private_h
#define MPMapControl_Private_h

#import "MPMapControl.h"
#import "MapsIndoorsCore/MapsIndoorsCore-Swift.h"


NS_ASSUME_NONNULL_BEGIN


@interface MPMapControl ()

- (void)updateViewModels;
- (void)updateSelectedLocationOnMap:(MPLocation * _Nullable)selectedLocation;
- (void)showAreaOfLocations:(MPLocation*)location;
- (void)reloadTilelayer;

@end

NS_ASSUME_NONNULL_END


#endif /* MPMapControl_Private_h */
