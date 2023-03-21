//
//  MPDirectionsServiceImpl.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 30/01/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPDirectionsServiceInternal.h"
#import "MPRoutingProvider.h"

NS_ASSUME_NONNULL_BEGIN


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPDirectionsServiceImpl : NSObject

@property (nonatomic, strong, nullable) NSString*                       solutionId;
@property (nonatomic, strong, nullable) NSString*                       googleApiKey;
@property (nonatomic, strong, nullable) NSString*                       language;

/**
 The maximum number of elements to "spend" in each call to the Distance Matrix API.
 */
@property (nonatomic, class) NSUInteger     maxElementsPerGoogleDistanceMatrixRequest;

/**
 Get a route!

 - Parameter origin: from
 - Parameter destination: to
 - Parameter mode: travel mode
 - Parameter restrictions: restrictions
 - Parameter departureTime: departureTime
 - Parameter arrivalTime: arrivalTime
 - Parameter handler: completion block, always called on the main queue.
 */
- (void)routingFrom:(id<MPLocation>)origin to:(id<MPLocation>)destination by:(NSString *)mode avoid:(nullable NSArray *)restrictions depart:(nullable NSDate *)departureTime arrive:(nullable NSDate *)arrivalTime userRoles:(nullable NSArray<MPUserRole*>*)userRoles completionHandler:(mpRouteHandlerBlockType)handler;

@end

NS_ASSUME_NONNULL_END
