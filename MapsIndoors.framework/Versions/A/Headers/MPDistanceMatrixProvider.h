//
//  MPDistanceMatrixProvider.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 21/09/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPDistanceMatrixResult.h"


@class MPUserRole;
typedef void(^mpMatrixHandlerBlockType)(MPDistanceMatrixResult* _Nullable matrixResult, NSError* _Nullable error);


@protocol MPDistanceMatrixProviderDelegate <NSObject>
/**
 Routing result ready event method.
 @param  RoutingCollection The Routing data collection.
 */
@required
- (void) onDistanceMatrixResultReady: (nonnull MPDistanceMatrixResult*)distanceMatrixResult;
@end


@interface MPDistanceMatrixProvider : NSObject

@property (nonatomic, weak, nullable) id <MPDistanceMatrixProviderDelegate> delegate;
@property (nonatomic, strong, nullable) NSString* solutionId;
@property (nonatomic, strong, nullable) NSString* googleApiKey;
@property (nonatomic, strong, nullable) NSString* graphId;
@property (nonatomic, strong, nullable) NSString* vehicle;

#pragma mark - MapsIndoors distance matrix

- (void) getDistanceMatrixWithOrigins:(nonnull NSArray*)origins
                         destinations:(nonnull NSArray*)destinations
                           travelMode:(nonnull NSString*)travelMode
                                avoid:(nullable NSArray*)restrictions
                               depart:(nullable NSDate*)departureTime
                               arrive:(nullable NSDate*)arrivalTime
                            userRoles:(nullable NSArray<MPUserRole*>*)userRoles
                    completionHandler:(nullable mpMatrixHandlerBlockType)handler;

- (void) getDistanceMatrixWithOrigins:(nonnull NSArray*)origins
                         destinations:(nonnull NSArray*)destinations
                           travelMode:(nonnull NSString*)travelMode
                                avoid:(nullable NSArray*)restrictions
                               depart:(nullable NSDate*)departureTime
                               arrive:(nullable NSDate*)arrivalTime
                    completionHandler:(nullable mpMatrixHandlerBlockType)handler;

- (void) getDistanceMatrixWithOrigins:(nonnull NSArray*)origins
                         destinations:(nonnull NSArray*)destinations
                           travelMode:(nonnull NSString*)travelMode;


#pragma mark - Google distance matrix
- (void) getGoogleDistanceMatrixWithOrigins:(nonnull NSArray*)origins
                               destinations:(nonnull NSArray*)destinations
                                 travelMode:(nonnull NSString*)travelMode
                                      avoid:(nullable NSArray*)restrictions
                                     depart:(nullable NSDate*)departureTime
                                     arrive:(nullable NSDate*)arrivalTime
                          completionHandler:(nullable mpMatrixHandlerBlockType)handler;

- (void) getGoogleDistanceMatrixWithOrigins:(nonnull NSArray*)origins
                               destinations:(nonnull NSArray*)destinations
                                 travelMode:(nonnull NSString*)travelMode;

@end
