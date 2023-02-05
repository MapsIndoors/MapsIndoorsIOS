//
//  MPRoutingProvider.h
//  Indoor
//
//  Created by Daniel Nielsen on 1/14/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import "MPRoutingProvider.h"


/**
 The strategy for selecting routing service.

 - RoutingServiceSelection_Auto: Use offline routing IF the app contains embedded routing graphs.
 - RoutingServiceSelection_ForceOnlineRouting: Always use the online routing service.
 - RoutingServiceSelection_ForceOfflineRouting: Always use offline/device-local routing.  Routing graphs need not be embedded, in which case routing graphs are downloaded on the first routing request.
 */
typedef NS_ENUM(NSUInteger, RoutingServiceSelection) {
    RoutingServiceSelection_Auto,
    RoutingServiceSelection_ForceOnlineRouting,
    RoutingServiceSelection_ForceOfflineRouting
};


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPRoutingProvider (Private)

/**
 Global override point to control the selection of online vs offline routing service.
 Use this to for example force using the online routing service:
    MPRoutingProvider.globalRoutingServiceSelectionStrategy = RoutingServiceSelection_ForceOnlineRouting;
 
 All instances of MPRoutingProvider will apply changes to globalRoutingServiceSelectionStrategy on future routing requests;
 ongoing routing requests are not affected by changes to globalRoutingServiceSelectionStrategy.
 */
@property (nonatomic, class) RoutingServiceSelection    globalRoutingServiceSelectionStrategy;

@end

