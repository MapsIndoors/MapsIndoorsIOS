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
#import "MPSolution.h"

@class MPMemoryCache;
@protocol MPMapConfig;

NS_ASSUME_NONNULL_BEGIN

@interface MapsIndoors ()

@property (class, readonly) MPLocationService* locationService;
@property (class) id<MPMapConfig> mapConfig;

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

@property (class, readonly) MPMemoryCache* memoryCache;

/**
 Gets the current MapsIndoors API key.
 @return The MapsIndoors API key as a string value.
 */
+ (nullable NSString*) getMapsIndoorsAPIKey;

/**
 Gets the current Google API key.
 @return The Google API key as a string value.
 */
+ (nullable NSString*) getGoogleAPIKey;

@end

NS_ASSUME_NONNULL_END
