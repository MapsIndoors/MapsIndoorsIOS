//
//  MPLocationsObserver.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 27/10/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPLocation.h"
#import "MPLocationSourceStatus.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MPLocationSource;

@protocol MPLocationsObserver<NSObject>

- (void)onLocationsUpdate:(NSArray<MPLocation *> *)locations source:(id<MPLocationSource>)source;

- (void)onLocationsDelete:(NSArray<NSString *> *)locations source:(id<MPLocationSource>)source;

- (void)onStatusChange:(MPLocationSourceStatus)status source:(id<MPLocationSource>)source;

@end

NS_ASSUME_NONNULL_END
