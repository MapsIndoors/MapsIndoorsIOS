//
//  MPRoutingProvider.h
//  Indoor
//
//  Created by Daniel Nielsen on 1/14/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPPoint.h"
#import "MPRoute.h"

@protocol MPRoutingProviderDelegate <NSObject>
/**
 * Routing result ready event method.
 * @param RoutingCollection The Routing data collection.
 */
@required
- (void) onRouteResultReady: (MPRoute*)route;
@end

typedef void(^mpRouteHandlerBlockType)(MPRoute* route, NSError* error);

@interface MPRoutingProvider : NSObject

@property (weak) id <MPRoutingProviderDelegate> delegate;
@property NSString* solutionId;
@property NSString* googleApiKey;
@property NSString* venue;
@property NSString* vehicle;

- (id)initWithArea:(NSString *)venueName;
- (id)initWithMapsIndoorsSolutionId:(NSString *)solutionId googleApiKey: (NSString*) googleApiKey;
- (void)getRoutingFrom:(MPPoint*)from to:(MPPoint*)to by:(NSString*)mode avoid:(NSArray*)restrictions;
- (void)getRoutingFrom:(MPPoint*)from to:(MPPoint*)to by:(NSString*)mode avoid:(NSArray*)restrictions depart:(NSDate*)departureTime arrive:(NSDate*)arrivalTime;
- (void)getGoogleRoutingFrom:(NSString*)from to:(NSString*)to by:(NSString*)mode avoid:(NSArray*)restrictions;
- (void)getGoogleRoutingFrom:(NSString*)from to:(NSString*)to by:(NSString*)mode avoid:(NSArray*)restrictions depart:(NSDate*)departureTime arrive:(NSDate*)arrivalTime;

- (void)getRoutingFrom:(MPPoint*)from to:(MPPoint*)to by:(NSString*)mode avoid:(NSArray*)restrictions completionHandler: (mpRouteHandlerBlockType)handler;
- (void)getRoutingFrom:(MPPoint*)from to:(MPPoint*)to by:(NSString*)mode avoid:(NSArray*)restrictions depart:(NSDate*)departureTime arrive:(NSDate*)arrivalTime completionHandler: (mpRouteHandlerBlockType)handler;
- (void)getGoogleRoutingFrom:(NSString*)from to:(NSString*)to by:(NSString*)mode avoid:(NSArray*)restrictions completionHandler: (mpRouteHandlerBlockType)handler;
- (void)getGoogleRoutingFrom:(NSString*)from to:(NSString*)to by:(NSString*)mode avoid:(NSArray*)restrictions depart:(NSDate*)departureTime arrive:(NSDate*)arrivalTime completionHandler: (mpRouteHandlerBlockType)handler;

@end	