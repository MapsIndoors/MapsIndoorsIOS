//
//  DirectionsService.h
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 03/09/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPRoutingProvider.h"
@import MapsIndoors;

@class MPDistanceMatrixProvider;
@class MPVenueProvider;

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Directions service
 */
@interface MPDirectionsServiceInternal : NSObject <MPDirectionsService>

/**
 The maximum number of elements to "spend" in each call to the Distance Matrix API.
 */
@property (nonatomic, class) NSUInteger     maxElementsPerGoogleDistanceMatrixRequest;

/**
 Get directions.

 - Parameter directionsQuery: Directions query
 - Parameter handler: Callback handler block
 */
- (void)routingWithQuery:(nonnull MPDirectionsQuery*)directionsQuery completionHandler: (nonnull mpRouteHandlerBlockType)handler;

@end
