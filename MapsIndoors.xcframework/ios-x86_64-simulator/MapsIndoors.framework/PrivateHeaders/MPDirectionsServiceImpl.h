//
//  MPDirectionsServiceImpl.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 30/01/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPLocation.h"
#import "MPDirectionsService.h"


@class MPUserRole;


NS_ASSUME_NONNULL_BEGIN


@interface MPDirectionsServiceImpl : NSObject

@property (nonatomic, weak, nullable) id <MPRoutingProviderDelegate>    delegate;
@property (nonatomic, strong, nullable) NSString*                       solutionId;
@property (nonatomic, strong, nullable) NSString*                       googleApiKey;
@property (nonatomic, strong, nullable) NSString*                       language;

/**
 The maximum number of elements to "spend" in each call to the Distance Matrix API.
 */
@property (nonatomic, class) NSUInteger     maxElementsPerGoogleDistanceMatrixRequest;

/**
 Get a route!

 @param origin from
 @param destination to
 @param mode travel mode
 @param restrictions restrictions
 @param departureTime departureTime
 @param arrivalTime arrivalTime
 @param handler completion block, always called on the main queue.
 */
- (void)routingFrom:(MPLocation *)origin to:(MPLocation *)destination by:(NSString *)mode avoid:(nullable NSArray *)restrictions depart:(nullable NSDate *)departureTime arrive:(nullable NSDate *)arrivalTime userRoles:(nullable NSArray<MPUserRole*>*)userRoles completionHandler:(nullable mpRouteHandlerBlockType)handler;

@end


NS_ASSUME_NONNULL_END
