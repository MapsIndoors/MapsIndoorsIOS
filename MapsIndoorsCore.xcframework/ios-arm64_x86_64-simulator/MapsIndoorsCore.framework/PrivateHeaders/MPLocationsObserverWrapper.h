//
//  MPLocationsObserverWrapper.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 19/06/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapsIndoors;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPLocationsObserverWrapper : NSObject

- (instancetype)initWithObserver:(id<MPLocationsObserver>)observer;

@property (weak, nullable, readonly) id<MPLocationsObserver> locationsObserver;

@end

NS_ASSUME_NONNULL_END
