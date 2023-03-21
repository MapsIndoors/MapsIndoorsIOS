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
#import "MPSolutionInternal.h"

@class MPMemoryCache;
@class MPMapConfig;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MapsIndoorsLegacy ()

@property (class, readonly) MPLocationService* locationService;

+ (nullable MPMapsIndoorsLocationSource*) defaultLocationSource;

@property (class, readonly) MPMemoryCache* memoryCache;

/**
 Gets the current Google API key.
 - Returns: The Google API key as a string value.
 */
+ (nullable NSString*) getGoogleAPIKey;

@end

NS_ASSUME_NONNULL_END
