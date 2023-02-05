//
//  MPGraphPathFinder.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 02/10/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MPGraphNode;
@class MPGraphEdge;


typedef NS_ENUM( NSUInteger, MPPathfindingAlgorithm ) {
    MPPathfindingAlgorithmDijkstra,
    MPPathfindingAlgorithmAStar,
};


NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPGraphPathFinder : NSObject

@property (nonatomic, class) MPPathfindingAlgorithm     preferredPathfindingAlgorithm;

/// Find path from startNodeId to endNodeId through nodes and edges, using the preferredPathfindingAlgorithm.
/// @param startNodeId startNodeId Start node id
/// @param endNodeId endNodeId End node id
/// @param nodes Graph nodes
/// @param edges Graph edges
+ (nullable NSArray<MPGraphNode*>*) findPathFromStartNode:(NSUInteger)startNodeId endNode:(NSUInteger)endNodeId usingNodes:(NSArray<MPGraphNode*>*)nodes andEdges:(NSArray<MPGraphEdge*>*)edges;

/// Find path from startNodeId to endNodeId through nodes and edges, using the specified path finding algorithm.
/// @param startNodeId startNodeId Start node id
/// @param endNodeId endNodeId End node id
/// @param nodes Graph nodes
/// @param edges Graph edges
/// @param pathFindingAlgorithm Path finding algorithm
+ (nullable NSArray<MPGraphNode*>*) findPathFromStartNode:(NSUInteger)startNodeId endNode:(NSUInteger)endNodeId usingNodes:(NSArray<MPGraphNode*>*)nodes andEdges:(NSArray<MPGraphEdge*>*)edges andAlgorithm:(MPPathfindingAlgorithm)pathFindingAlgorithm;

/// Find path from startNodeId to endNodeId through nodes and edges, using A*.
/// @param startNodeId startNodeId Start node id
/// @param endNodeId endNodeId End node id
/// @param nodes Graph nodes
/// @param edges Graph edges
+ (nullable NSArray<MPGraphNode*>*) findAStarPathFromStartNode:(NSUInteger)startNodeId endNode:(NSUInteger)endNodeId usingNodes:(NSArray<MPGraphNode*>*)nodes andEdges:(NSArray<MPGraphEdge*>*)edges;

/// Find path from startNodeId to endNodeId through nodes and edges, using Dijkstra.
/// @param startNodeId startNodeId Start node id
/// @param endNodeId endNodeId End node id
/// @param nodes Graph nodes
/// @param edges Graph edges
+ (nullable NSArray<MPGraphNode*>*) findDijkstraPathFromStartNode:(NSUInteger)startNodeId endNode:(NSUInteger)endNodeId usingNodes:(NSArray<MPGraphNode*>*)nodes andEdges:(NSArray<MPGraphEdge*>*)edges;

@end

NS_ASSUME_NONNULL_END
