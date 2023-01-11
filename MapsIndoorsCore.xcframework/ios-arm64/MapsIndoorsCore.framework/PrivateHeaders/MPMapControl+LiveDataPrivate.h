//
//  MPMapControl+LiveDataPrivate.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 18/11/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "MPMapControl.h"

@class MPLocationDataset;

NS_ASSUME_NONNULL_BEGIN

@interface MPMapControl (LiveDataPrivate)

@property (nonatomic, readonly) MPLocationDataset*     locationData;

- (void)updateLiveAppearanceForLocations:(NSArray<MPLocation *> * _Nonnull)locations;
- (void)updateLiveSubscriptionsForLocations:(NSArray<MPLocation*>*)locations;
- (void)disableLiveData;

@end

NS_ASSUME_NONNULL_END
