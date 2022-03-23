//
//  MPMapsIndoors+Private.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 26/10/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "MPMapsIndoors.h"
#import "MPLocationService.h"
#import "MPMemoryCache.h"
#import "MPSolution.h"

NS_ASSUME_NONNULL_BEGIN

@interface MapsIndoors (Private)

@property (class, readonly) MPLocationService* locationService;

+ (nullable MPMapsIndoorsLocationSource*) defaultLocationSource;

/**
 Provides your Solution Id to the MapsIndoors SDK for iOS. This key is generated for your solution.
 @param solutionId The MapsIndoors content key
 @return YES if the Solution Id was successfully provided
 */
+ (BOOL) provideSolutionId:(NSString*)solutionId;

/**
 Reset MapsIndoors API key, to facilitate the "log out" functionality of the POC app.
 */
+ (void) __unProvideAPIKey;

/**
 Controls whether overlapping map markers can be resolved by hiding some of the overlapping items.
 Default value is YES;
 */
@property(class) BOOL   locationHidingEnabled;

@property (class, readonly) MPMemoryCache* memoryCache;

+ (MPSolution*) currentSolution;

@end

NS_ASSUME_NONNULL_END
