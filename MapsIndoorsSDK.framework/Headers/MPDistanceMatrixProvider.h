//
//  MPDistanceMatrixProvider.h
//  MapsIndoorSDK
//
//  Created by Daniel Nielsen on 21/09/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPDistanceMatrixResult.h"

typedef void(^mpMatrixHandlerBlockType)(MPDistanceMatrixResult* matrixResult, NSError* error);

@protocol MPDistanceMatrixProviderDelegate <NSObject>
/**
 * Routing result ready event method.
 * @param RoutingCollection The Routing data collection.
 */
@required
- (void) onDistanceMatrixResultReady: (MPDistanceMatrixResult*)distanceMatrixResult;
@end

@interface MPDistanceMatrixProvider : NSObject

@property (weak) id <MPDistanceMatrixProviderDelegate> delegate;
@property NSString* solutionId;
@property NSString* googleApiKey;
@property NSString* graphId;
@property NSString* vehicle;

- (void)getDistanceMatrixWithOrigins:(NSArray*) origins destinations:(NSArray*)destinations travelMode: (NSString*)travelMode avoid:(NSArray*)restrictions depart:(NSDate*)departureTime arrive:(NSDate*)arrivalTime completionHandler: (mpMatrixHandlerBlockType)handler;

- (void)getDistanceMatrixWithOrigins:(NSArray*) origins destinations:(NSArray*)destinations travelMode: (NSString*)travelMode;

- (void)getGoogleDistanceMatrixWithOrigins:(NSArray*) origins destinations:(NSArray*)destinations travelMode: (NSString*)travelMode avoid:(NSArray*)restrictions depart:(NSDate*)departureTime arrive:(NSDate*)arrivalTime completionHandler: (mpMatrixHandlerBlockType)handler;

- (void)getGoogleDistanceMatrixWithOrigins:(NSArray*) origins destinations:(NSArray*)destinations travelMode: (NSString*)travelMode;

@end
