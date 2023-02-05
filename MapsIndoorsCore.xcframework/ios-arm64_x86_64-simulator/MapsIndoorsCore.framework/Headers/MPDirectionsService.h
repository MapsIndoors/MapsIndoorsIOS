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




#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Directions service
 */
@interface MPDirectionsService : NSObject

/**
 The maximum number of elements to "spend" in each call to the Distance Matrix API.
 */
@property (nonatomic, class) NSUInteger     maxElementsPerGoogleDistanceMatrixRequest;

/**
 Get directions.

 @param directionsQuery Directions query
 @param handler Callback handler block
 */
- (void)routingWithQuery:(nonnull MPDirectionsQuery*)directionsQuery completionHandler: (nonnull mpRouteHandlerBlockType)handler;

@end
