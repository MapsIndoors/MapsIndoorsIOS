//
//  MPRouteNetworkData.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 07/11/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN


@class MPRouteNetwork;
@class MPRouteNetworkEntryPoint;
@class MPPoint;


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPRouteNetworkData : NSObject

- (nullable instancetype) initWithData:(NSData*)data error:(NSError**)error;
- (nullable instancetype) init NS_UNAVAILABLE;

@property (nonatomic, strong, readonly, nullable) NSArray<MPRouteNetwork*>*                 networks;
@property (nonatomic, strong, readonly, nullable) NSDictionary<NSString*,MPRouteNetwork*>*  networkFromGraphId;         // keys are *always* lowercase

/**
 Get all entry points for a given graph.

 @param routingGraphId GraphId to get entry points for.
 @return return List of routing entry points.
 */
- (NSArray<MPRouteNetworkEntryPoint*>*) networkEntryPointsForRoutingGraphId:(NSString*)routingGraphId accessTokens:(nullable NSSet<NSString*>*)accessTokens;

/**
 Given a MPPoint, return the corresponding graphId if any.

 @param point point to determine graphId for
 @return graphId. always lowercase.
 */
- (nullable NSString*) getGraphIdFromPoint:(MPPoint*)point;

@end


NS_ASSUME_NONNULL_END
