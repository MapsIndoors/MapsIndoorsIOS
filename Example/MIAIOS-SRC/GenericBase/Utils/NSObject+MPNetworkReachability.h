//
//  NSObject+MPNetworkReachability.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 06/01/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>


typedef void (^MPNetworkReachabilityBlock)( BOOL isNetworkReachable );


@interface NSObject (MPNetworkReachability)

@property (nonatomic, readonly) BOOL    mp_isNetworkReachable;

- (void) mp_onReachabilityChange:(nullable MPNetworkReachabilityBlock)block;
- (void) mp_stopMonitoringReachabilityChanges;

@end
