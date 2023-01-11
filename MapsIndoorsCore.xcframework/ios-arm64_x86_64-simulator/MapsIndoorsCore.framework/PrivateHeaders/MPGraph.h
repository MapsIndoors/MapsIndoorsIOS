//
//  MPGraph.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 24/11/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPLocationCoordinate3D.h"


NS_ASSUME_NONNULL_BEGIN


@class MPGraphNode;
@class MPGraphEdge;


@interface MPGraph : NSObject

@property (nonatomic, readonly, strong, nullable) NSArray<MPGraphNode*>*    nodes;

@property (nonatomic, readonly, strong, nullable) NSArray<MPGraphNode*>*    entryPointNodes;

@property (nonatomic, readonly, strong, nullable) NSArray<MPGraphEdge*>*    edges;
@property (nonatomic, readonly) NSUInteger                                  edgeCount;

@property (nonatomic, strong, readonly, nullable) NSArray<MPGraphNode*>*    restrictedGraphNodes;
@property (nonatomic, strong, readonly, nullable) NSArray<MPGraphEdge*>*    restrictedGraphEdges;

@property (nonatomic, readonly) NSUInteger                                  nodeIdForFirstTemporaryGraphNode;
@property (nonatomic, strong, readonly, nullable) NSArray<MPGraphNode*>*    temporaryGraphNodes;
@property (nonatomic, strong, readonly, nullable) NSArray<MPGraphEdge*>*    temporaryGraphEdges;

+ (nullable instancetype) newWithNodes :(NSArray<MPGraphNode*>*)nodes edges:(NSArray<MPGraphEdge*>*)edges entryPointNodes:(nullable NSArray<MPGraphNode*>*)entryPointNodes;
- (nullable instancetype) initWithNodes:(NSArray<MPGraphNode*>*)nodes edges:(NSArray<MPGraphEdge*>*)edges entryPointNodes:(nullable NSArray<MPGraphNode*>*)entryPointNodes;
- (nullable instancetype) init NS_UNAVAILABLE;

- (nullable MPGraphNode*) nodeAtIndex:(NSUInteger)nodeIndex;
- (nullable NSArray<MPGraphEdge*>*) edgesForNodeAtIndex:(NSUInteger)nodeIndex;

- (nullable NSArray<MPGraphNode*>*) findPathFromNode:(MPGraphNode*)startNode toNode:(MPGraphNode*)endNode restrictions:(nullable NSArray<NSString*>*)restrictions accessTokens:(nullable NSSet<NSString*>*)accessTokens;
- (nullable NSArray<MPGraphEdge*>*) edgePathFromNodePath:(NSArray<MPGraphNode*>*)nodePath;

- (void) setTemporaryGraphNodes:(NSArray<MPGraphNode*>*)nodes andEdges:(NSArray<MPGraphEdge*>*)edges;
- (void) clearTemporaryGraphNodesAndEdges;

/**
 Find the nodes in the graph that is closest to the given coordinate.

 To search on all floors, set coordinate.floorId = NSNotFound.
 
 @param coordinate Latitude, longitude and optionally floor index to search for.
 @param radius  Optional radius limit.  0 means no limit.
 @param maxResults Optional limit on the number of results.  0 means no limit.
 @return Array of MPGraphNode instances matching criteria.
 */
- (nullable NSArray<MPGraphNode*>*) closestNodesToCoordinate:(MPLocationCoordinate3D)coordinate radius:(double)radius maxResults:(NSUInteger)maxResults;

/**
 Find the edges in the graph that is closest to the given coordinate.

 To search on all floors, set coordinate.floorId = NSNotFound.

 Note: this method disregards temporary graph edges, and only searches the 'original' graph content.

 @param coordinate Latitude, longitude and optionally floor index to search for.
 @param radius  Optional radius limit.  0 means no limit.
 @param maxResults Optional limit on the number of results.  0 means no limit.
 @return Array of MPGraphEdge instances matching criteria.
 */
- (nullable NSArray<MPGraphEdge*>*) closestEdgesToCoordinate:(MPLocationCoordinate3D)coordinate radius:(double)radius maxResults:(NSUInteger)maxResults;

/**
 Get all graph-edges on a specific floor that have a bounding box overlap with the given bounding box.

 @param northEast NE corner of bounding box
 @param southWest SW corner of bounding box
 @param floor Floor index

 @return array of graph edges.
 */
- (NSArray<MPGraphEdge*>*) edgesWithBoundingBoxOverlappingNorthEast:(CLLocationCoordinate2D)northEast southWest:(CLLocationCoordinate2D)southWest floor:(NSInteger)floor;

@end


NS_ASSUME_NONNULL_END
