//
//  DirectionsService.h
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 03/09/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import "MPLocation.h"
#import "MPDistanceMatrixProvider.h"
#import "MPVenueProvider.h"
#import "MPRoutingProvider.h"
#import "MPDirectionsQuery.h"

@interface MPDirectionsService : NSObject

/**
 The maximum number of elements to "spend" in each call to the Distance Matrix API.
 */
@property (nonatomic, class) NSUInteger     maxElementsPerGoogleDistanceMatrixRequest;

@property (weak) id <MPRoutingProviderDelegate> delegate;
@property NSString* solutionId;
@property NSString* googleApiKey;
@property NSString* language;

- (id)initWithMapsIndoorsSolutionId:(NSString *)solutionId googleApiKey: (NSString*) googleApiKey DEPRECATED_MSG_ATTRIBUTE("Use [MapsIndoors provideAPIKey:::] to apply MapsIndoors API key,  content key and Google API key");
- (void)routingFrom:(MPLocation *)from to:(MPLocation *)to by:(NSString *)mode avoid:(NSArray *)restrictions depart:(NSDate *)departureTime arrive:(NSDate *)arrivalTime DEPRECATED_MSG_ATTRIBUTE("Use routingWithQuery: instead");
- (void)routingFrom:(MPLocation *)from to:(MPLocation *)to by:(NSString *)mode DEPRECATED_MSG_ATTRIBUTE("Use routingWithQuery: instead");

- (void)routingFrom:(MPLocation *)from to:(MPLocation *)to by:(NSString *)mode avoid:(NSArray *)restrictions depart:(NSDate *)departureTime arrive:(NSDate *)arrivalTime completionHandler: (mpRouteHandlerBlockType)handler DEPRECATED_MSG_ATTRIBUTE("Use routingWithQuery:completionHandler: instead");
- (void)routingFrom:(MPLocation *)from to:(MPLocation *)to by:(NSString *)mode completionHandler: (mpRouteHandlerBlockType)handler DEPRECATED_MSG_ATTRIBUTE("Use routingWithQuery:completionHandler: instead");
- (void)routingWithQuery:(MPDirectionsQuery*)directionsQuery completionHandler: (mpRouteHandlerBlockType)handler;
- (void)routingWithQuery:(MPDirectionsQuery*)directionsQuery;

@end
