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
 @deprecated
 */
@property (nonatomic, strong, nullable) NSString* solutionId DEPRECATED_MSG_ATTRIBUTE("Use [MapsIndoors provideAPIKey:::] to apply MapsIndoors API key, content key and Google API key");
/**
 @deprecated
 */
@property (nonatomic, strong, nullable) NSString* googleApiKey DEPRECATED_MSG_ATTRIBUTE("Use [MapsIndoors provideAPIKey:::] to apply MapsIndoors API key, content key and Google API key");
/**
 @deprecated
 */
@property (nonatomic, strong, nullable) NSString* language DEPRECATED_MSG_ATTRIBUTE("Use [MapsIndoors setLanguage:] to apply language globally");
/**
 @deprecated
 */
- (nullable instancetype)initWithMapsIndoorsSolutionId:(nullable NSString *)solutionId googleApiKey: (nullable NSString*) googleApiKey DEPRECATED_MSG_ATTRIBUTE("Use [MapsIndoors provideAPIKey:::] to apply MapsIndoors API key,  content key and Google API key");
/**
 @deprecated
 */
- (void)routingFrom:(nonnull MPLocation *)from to:(nonnull MPLocation *)to by:(nonnull NSString *)mode avoid:(nullable NSArray *)restrictions depart:(nullable NSDate *)departureTime arrive:(nullable NSDate *)arrivalTime DEPRECATED_MSG_ATTRIBUTE("Use routingWithQuery: instead");
/**
 @deprecated
 */
- (void)routingFrom:(nonnull MPLocation *)from to:(nonnull MPLocation *)to by:(nonnull NSString *)mode DEPRECATED_MSG_ATTRIBUTE("Use routingWithQuery: instead");
/**
 @deprecated
 */
- (void)routingFrom:(nonnull MPLocation *)from to:(nonnull MPLocation *)to by:(nonnull NSString *)mode avoid:(nullable NSArray *)restrictions depart:(nullable NSDate *)departureTime arrive:(nullable NSDate *)arrivalTime completionHandler: (nullable mpRouteHandlerBlockType)handler DEPRECATED_MSG_ATTRIBUTE("Use routingWithQuery:completionHandler: instead");
/**
 @deprecated
 */
- (void)routingFrom:(nonnull MPLocation *)from to:(nonnull MPLocation *)to by:(nonnull NSString *)mode completionHandler: (nullable mpRouteHandlerBlockType)handler DEPRECATED_MSG_ATTRIBUTE("Use routingWithQuery:completionHandler: instead");
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
