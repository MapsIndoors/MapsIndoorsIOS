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


@class MPUserRole;

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Directions service delegate
 */
@protocol MPRoutingProviderDelegate <NSObject>
/**
 Routing result ready event method.
 - Parameter route: The Routing data collection.
 */
@required
- (void) onRouteResultReady: (nonnull MPRoute*)route;
@end

/**
 Callback handler for route result

 - Parameter route: Route object.
 - Parameter error: Error object.
 */
typedef void(^mpRouteHandlerBlockType)(MPRoute* _Nullable route, NSError* _Nullable error);


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPRoutingProvider : NSObject

@property (nonatomic, weak, nullable) id <MPRoutingProviderDelegate> delegate;
@property (nonatomic, strong, nullable) NSString* solutionId;
@property (nonatomic, strong, nullable) NSString* googleApiKey;
@property (nonatomic, strong, nullable) NSString* venue;
@property (nonatomic, strong, nullable) NSString* vehicle;
@property (nonatomic, strong, nullable) NSString* language;


#pragma mark - Initializers
- (nullable instancetype) initWithArea:(nonnull NSString *)venueName;
- (nullable instancetype) initWithMapsIndoorsSolutionId:(nonnull NSString *)solutionId googleApiKey: (nonnull NSString*) googleApiKey;

#pragma mark - Delegate-based routing methods
- (void) getRoutingFrom:(nonnull MPPoint*)from to:(nonnull MPPoint*)to by:(nonnull NSString*)mode avoid:(nullable NSArray*)restrictions;
- (void) getRoutingFrom:(nonnull MPPoint*)from to:(nonnull MPPoint*)to by:(nonnull NSString*)mode avoid:(nullable NSArray*)restrictions depart:(nullable NSDate*)departureTime arrive:(nullable NSDate*)arrivalTime;
- (void) getRoutingFrom:(nonnull MPPoint*)from to:(nonnull MPPoint*)to by:(nonnull NSString*)mode avoid:(nullable NSArray*)restrictions depart:(nullable NSDate*)departureTime arrive:(nullable NSDate*)arrivalTime userRoles:(nullable NSArray<MPUserRole*>*)userRoles;
- (void) getGoogleRoutingFrom:(nonnull NSString*)from to:(nonnull NSString*)to by:(nonnull NSString*)mode avoid:(nullable NSArray*)restrictions;
- (void) getGoogleRoutingFrom:(nonnull NSString*)from to:(nonnull NSString*)to by:(nonnull NSString*)mode avoid:(nullable NSArray*)restrictions depart:(nullable NSDate*)departureTime arrive:(nullable NSDate*)arrivalTime;

#pragma mark - completion handler based routing methods
- (void) getRoutingFrom:(nonnull MPPoint*)from to:(nonnull MPPoint*)to by:(nonnull NSString*)mode avoid:(nullable NSArray*)restrictions completionHandler:(nullable mpRouteHandlerBlockType)handler;
- (void) getRoutingFrom:(nonnull MPPoint*)from to:(nonnull MPPoint*)to by:(nonnull NSString*)mode avoid:(nullable NSArray*)restrictions depart:(nullable NSDate*)departureTime arrive:(nullable NSDate*)arrivalTime completionHandler:(nullable mpRouteHandlerBlockType)handler;
- (void) getRoutingFrom:(nonnull MPPoint*)from to:(nonnull MPPoint*)to by:(nonnull NSString*)mode avoid:(nullable NSArray*)restrictions depart:(nullable NSDate*)departureTime arrive:(nullable NSDate*)arrivalTime userRoles:(nullable NSArray<MPUserRole*>*)userRoles completionHandler:(nullable mpRouteHandlerBlockType)handler;
- (void) getGoogleRoutingFrom:(nonnull NSString*)from to:(nonnull NSString*)to by:(nonnull NSString*)mode avoid:(nullable NSArray*)restrictions completionHandler:(nullable mpRouteHandlerBlockType)handler;
- (void) getGoogleRoutingFrom:(nonnull NSString*)from to:(nonnull NSString*)to by:(nonnull NSString*)mode avoid:(nullable NSArray*)restrictions depart:(nullable NSDate*)departureTime arrive:(nullable NSDate*)arrivalTime completionHandler:(nullable mpRouteHandlerBlockType)handler;

@end	
