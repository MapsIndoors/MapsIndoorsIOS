//
//  MPLiveLocationSource.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 15/06/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPLocationSource.h"

@class MPLiveUpdate;

NS_ASSUME_NONNULL_BEGIN

@interface MPMapsIndoorsLocationSource (LiveData)

- (void)notifyLiveUpdate:(nonnull MPLiveUpdate *)liveUpdate;

@end

NS_ASSUME_NONNULL_END
