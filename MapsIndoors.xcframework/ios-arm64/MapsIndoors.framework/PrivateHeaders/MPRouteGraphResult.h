//
//  MPRouteGraph.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 09/01/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "MPRouteEdge.h"
#import "MPRouteNode.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPRouteGraphResult : NSObject

@property (nonatomic, strong, readonly) NSArray<id<MPRouteNodeProtocol>>* nodes;
@property (nonatomic, strong, readonly) NSArray<id<MPRouteEdgeProtocol>>* edges;

- (instancetype) initWithEdges: (NSArray<id<MPRouteEdgeProtocol>>*) edges nodes: (NSArray<id<MPRouteNodeProtocol>>*) nodes;
- (id<MPRouteNodeProtocol>) getNodeByIndex:(NSUInteger) nodeIndex;
- (void) addMIEdge: (MIEdge*) edge;

@end

NS_ASSUME_NONNULL_END
