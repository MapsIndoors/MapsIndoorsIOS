//
//  DirectionsService.h
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 03/09/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPDefines.h"
#import "MPRoutingProvider.h"

@class MPLocation;
@class MPDistanceMatrixProvider;
@class MPVenueProvider;
@class MPDirectionsQuery;




/**
 Directions service
 */
@interface MPDirectionsService : NSObject

/**
 The maximum number of elements to "spend" in each call to the Distance Matrix API.
 */
@property (nonatomic, class) NSUInteger     maxElementsPerGoogleDistanceMatrixRequest;
/**
 Directions service delegate
 */
@property (nonatomic, weak, nullable) id <MPRoutingProviderDelegate> delegate;
/**
 Get directions.

 @param directionsQuery Directions query
 @param handler Callback handler block
 */
- (void)routingWithQuery:(nonnull MPDirectionsQuery*)directionsQuery completionHandler: (nullable mpRouteHandlerBlockType)handler;
/**
 Get directions.
 
 @param directionsQuery Directions query
 */
- (void)routingWithQuery:(nonnull MPDirectionsQuery*)directionsQuery;

@end
