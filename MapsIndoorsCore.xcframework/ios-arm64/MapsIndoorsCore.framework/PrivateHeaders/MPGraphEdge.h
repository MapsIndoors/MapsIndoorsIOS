//
//  MPGraphEdge.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 23/11/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+MPPropertyClassification.h"
#import "MIEdge.h"
#import "MPRouteEdge.h"

NS_ASSUME_NONNULL_BEGIN

@class MPHighway;
@protocol MPGraphEdgePropertyProtocol;


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPGraphEdge : NSObject <NSCopying, MPRouteEdgeProtocol>

/**
 Node index of node at one end of the edge
 */
@property (nonatomic) NSUInteger        u;

/**
 Node index of node at one end of the edge
 */
@property (nonatomic) NSUInteger        v;

/**
 Indicates whether this edge is weighted or not.
 Defaults to YES.
 */
@property (nonatomic) BOOL              weighted;

/**
 The weight associated with this edge.
 If this edge is not weighted, this is always returns 0.
 */
@property (nonatomic) NSInteger         weight;

/**
 Indicates whether this edge is directed or not.
 Defaults to NO.
 */
@property (nonatomic, readonly) BOOL    directed;   // "oneway" flag

@property (nonatomic, readonly)                   MPHighway*        highway;
@property (nonatomic, readonly, strong, nullable) NSString*         context;
@property (nonatomic, readonly)                   NSUInteger        distance;       // mm
@property (nonatomic, readonly)                   double            speedFactor;
@property (nonatomic, readonly)                   NSTimeInterval    waittime;

@property (nonatomic, strong, nullable) NSArray<NSString*>*         restrictions;


/**
 Initalize an instance of MPGraphEdge, with the following defaults:
    weighted = YES
    weight = 0
    directed = NO

 - Parameter nodeIndex1: Node index of node at one end of the edge
 - Parameter nodeIndex2: Node index of node at one end of the edge
 - Returns: instance of MPGraphEdge
 */
- (nullable instancetype) initGraphEdgeBetween:(NSUInteger)nodeIndex1
                                           and:(NSUInteger)nodeIndex2
                                withProperties:(nullable id<MPGraphEdgePropertyProtocol>)properties
                    NS_DESIGNATED_INITIALIZER;

/**
 Create and initialize an MPGraphEdge.

 - Parameter nodeIndex1: Node index of node at one end of the edge
 - Parameter nodeIndex2: Node index of node at one end of the edge
 - Returns: instance of MPGraphEdge
 */
+ (nullable instancetype) newGraphEdgeBetween:(NSUInteger)nodeIndex1
                                          and:(NSUInteger)nodeIndex2
                               withProperties:(nullable id<MPGraphEdgePropertyProtocol>)properties;

/**
 Create a reversed version of the graph edge.

 - Returns: Reversed graph edge.
 */
- (MPGraphEdge*) reversed;

/**
 Check if this edge is equal to another edge.

 - Parameter otherEdge: MPGraphEdge to compare against
 - Returns: YES if equal, else NO.
 */
- (BOOL) isEqualToEdge:(MPGraphEdge*)otherEdge;

/**
 Check if this edge is accessible with the given access tokens.

 - Parameter accessTokens: Collection of acces tokens
 - Returns: YES if accessible, else NO.
 */
- (BOOL) isAccessibleWithAccessTokens:(nullable NSSet<NSString*>*)accessTokens;

/**
Generate MICommon representation of this edge.

- Parameter u: Start node.
- Parameter v: End node.
- Returns: The generated edge.
*/
- (MIEdge*) miEdgeWithNodeU:(MINode*)u v:(MINode*)v;

@end


NS_ASSUME_NONNULL_END
