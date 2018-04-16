//
//  NSObject+MPNetworkReachability.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 06/01/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "NSObject+MPNetworkReachability.h"
#import <KVOController/KVOController.h>


@implementation NSObject (MPNetworkReachability)

- (void) mp_onReachabilityChange:(nullable MPNetworkReachabilityBlock)block {
    
    [self mp_stopMonitoringReachabilityChanges];
    
    if ( block ) {
        [self.KVOController observe:AFNetworkReachabilityManager.sharedManager
                            keyPath:@"reachable"
                            options:NSKeyValueObservingOptionNew
                              block:^(id _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
                                  block( AFNetworkReachabilityManager.sharedManager.reachable );
                              }];
    }
}

- (void) mp_stopMonitoringReachabilityChanges {
    
    [self.KVOController unobserve:AFNetworkReachabilityManager.sharedManager keyPath:@"reachable"];
}

- (BOOL) mp_isNetworkReachable {
    
    return AFNetworkReachabilityManager.sharedManager.reachable;
}

@end
