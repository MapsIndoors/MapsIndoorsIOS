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


@interface MPDirectionsService : NSObject

/**
 The maximum number of elements to "spend" in each call to the Distance Matrix API.
 */
@property (nonatomic, class) NSUInteger     maxElementsPerGoogleDistanceMatrixRequest;

@property (nonatomic, weak, nullable) id <MPRoutingProviderDelegate> delegate;
@property (nonatomic, strong, nullable) NSString* solutionId MP_DEPRECATED_MSG_ATTRIBUTE("Use [MapsIndoors provideAPIKey:::] to apply MapsIndoors API key, content key and Google API key");
@property (nonatomic, strong, nullable) NSString* googleApiKey MP_DEPRECATED_MSG_ATTRIBUTE("Use [MapsIndoors provideAPIKey:::] to apply MapsIndoors API key, content key and Google API key");
@property (nonatomic, strong, nullable) NSString* language MP_DEPRECATED_MSG_ATTRIBUTE("Use [MapsIndoors setLanguage:] to apply language globally");

- (nullable instancetype)initWithMapsIndoorsSolutionId:(nullable NSString *)solutionId googleApiKey: (nullable NSString*) googleApiKey MP_DEPRECATED_MSG_ATTRIBUTE("Use [MapsIndoors provideAPIKey:::] to apply MapsIndoors API key,  content key and Google API key");
- (void)routingFrom:(nonnull MPLocation *)from to:(nonnull MPLocation *)to by:(nonnull NSString *)mode avoid:(nullable NSArray *)restrictions depart:(nullable NSDate *)departureTime arrive:(nullable NSDate *)arrivalTime MP_DEPRECATED_MSG_ATTRIBUTE("Use routingWithQuery: instead");
- (void)routingFrom:(nonnull MPLocation *)from to:(nonnull MPLocation *)to by:(nonnull NSString *)mode MP_DEPRECATED_MSG_ATTRIBUTE("Use routingWithQuery: instead");

- (void)routingFrom:(nonnull MPLocation *)from to:(nonnull MPLocation *)to by:(nonnull NSString *)mode avoid:(nullable NSArray *)restrictions depart:(nullable NSDate *)departureTime arrive:(nullable NSDate *)arrivalTime completionHandler: (nullable mpRouteHandlerBlockType)handler MP_DEPRECATED_MSG_ATTRIBUTE("Use routingWithQuery:completionHandler: instead");
- (void)routingFrom:(nonnull MPLocation *)from to:(nonnull MPLocation *)to by:(nonnull NSString *)mode completionHandler: (nullable mpRouteHandlerBlockType)handler MP_DEPRECATED_MSG_ATTRIBUTE("Use routingWithQuery:completionHandler: instead");
- (void)routingWithQuery:(nonnull MPDirectionsQuery*)directionsQuery completionHandler: (nullable mpRouteHandlerBlockType)handler;
- (void)routingWithQuery:(nonnull MPDirectionsQuery*)directionsQuery;

@end
