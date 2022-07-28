//
//  MPLiveDataMapManager.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 17/11/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPMappedLocationUpdateHandler.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPMappedLocationUpdateHandlerWrapper : NSObject

@property (nonatomic, weak, readwrite, nullable) id<MPMappedLocationUpdateHandler> handler;

@end

NS_ASSUME_NONNULL_END
