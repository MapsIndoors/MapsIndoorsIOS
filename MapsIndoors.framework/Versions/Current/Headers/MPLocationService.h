//
//  MPLocationService.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 06/11/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "MPLocationSource.h"

@class MPQuery;
@class MPFilter;
@class MPLocation;


NS_ASSUME_NONNULL_BEGIN

typedef void(^mpLocationsHandlerBlockType)(NSArray<MPLocation*>* _Nullable locations, NSError* _Nullable error);

@interface MPLocationService : NSObject

+ (instancetype) sharedInstance;
- (void)getLocationsUsingQuery:(nonnull MPQuery*)query filter:(nonnull MPFilter*)filter completionHandler:(nullable mpLocationsHandlerBlockType)handler;

@end

NS_ASSUME_NONNULL_END
