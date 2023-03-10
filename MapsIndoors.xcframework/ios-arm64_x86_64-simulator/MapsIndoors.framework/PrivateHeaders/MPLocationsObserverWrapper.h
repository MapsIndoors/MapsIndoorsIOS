//
//  MPLocationsObserverWrapper.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 19/06/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPLocationsObserver.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPLocationsObserverWrapper : NSObject

- (instancetype)initWithObserver:(id<MPLocationsObserver>)observer;

@property (weak, nullable, readonly) id<MPLocationsObserver> locationsObserver;

@end

NS_ASSUME_NONNULL_END
