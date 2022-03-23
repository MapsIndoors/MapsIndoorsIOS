//
//  MPMapControl+LiveData.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 17/11/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "MPMapControl.h"
#import "MPMappedLocationUpdateHandler.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Subscribing for and showing Live Data for locations in the visible map region. 
 */
@interface MPMapControl (LiveData)

/**
 Start subscribing for and showing Live Data for locations in the visible map region with given `MPLiveDomainType`. The SDK will handle rendering of the Live Data updates.
 Note that the SDK will set custom display rules for this rendering. Adding your own or resetting display rules while Live Data is enabled with default rendering may break the rendering for the current `MPMapControl` instance.
 */
- (void) enableLiveData:(nonnull NSString*)domainType;

/**
 Start subscribing for Live Data for locations in the visible map region with given `MPLiveDomainType`. Delegate will be called to handle display updates.
 */
- (void) enableLiveData:(nonnull NSString*)domainType handler:(nonnull id<MPMappedLocationUpdateHandler>)handler;

/**
 End subscribing for and showing Live Data for locations in the visible map region for given `MPLiveDomainType`.
 */
- (void) disableLiveData:(nonnull NSString*)domainType;

@end

NS_ASSUME_NONNULL_END
