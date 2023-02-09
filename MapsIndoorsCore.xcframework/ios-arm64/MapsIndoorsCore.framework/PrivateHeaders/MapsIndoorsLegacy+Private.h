//
//  MPMapsIndoorsLegacy+Private.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 26/10/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "MPMapsIndoorsLegacy.h"
#import "MPLocationService.h"
#import "MPSolution.h"

@class MPMemoryCache;
@class MPMapConfig;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MapsIndoorsLegacy ()

@property (class, readonly) MPLocationService* locationService;

+ (nullable MPMapsIndoorsLocationSource*) defaultLocationSource;

/**
 Provides your Solution Id to the MapsIndoors SDK for iOS. This key is generated for your solution.
 - Parameter solutionId: The MapsIndoors content key
 - Returns: YES if the Solution Id was successfully provided
 */
+ (BOOL) provideSolutionId:(NSString*)solutionId;

@property (class, readonly) MPMemoryCache* memoryCache;

/**
 Gets the current Google API key.
 - Returns: The Google API key as a string value.
 */
+ (nullable NSString*) getGoogleAPIKey;

@end

NS_ASSUME_NONNULL_END
