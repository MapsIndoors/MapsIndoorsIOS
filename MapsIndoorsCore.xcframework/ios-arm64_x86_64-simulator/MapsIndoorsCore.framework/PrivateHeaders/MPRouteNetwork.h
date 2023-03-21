//
//  MPRouteNetwork.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 07/11/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import "MPLocationCoordinate3D.h"
#import <CoreLocation/CoreLocation.h>
@import MapsIndoors;

@class MPGraph;
@class MPGraphNode;
@class MPGraphEdge;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPRouteNetwork : NSObject

@property (nonatomic, strong, readonly) NSString*           graphId;
@property (nonatomic, strong, readonly) NSDictionary*       nodeMapping;
@property (nonatomic, strong, readonly) NSDictionary*       edgeMapping;
@property (nonatomic, strong, readonly, nullable) NSArray*  flagMapping;
@property (nonatomic, strong, readonly) NSArray*            nodeData;
@property (nonatomic, strong, readonly) NSArray*            edgeData;
@property (nonatomic, strong, readonly) NSArray*            nodeAccess;
@property (nonatomic, strong, readonly) NSArray*            edgeAccess;
@property (nonatomic, strong, readonly, nullable) NSString* immutableNodes;     // Possible values: nil, @"", @"1-7,42,100-101"
@property (nonatomic, readonly) BOOL                        allowPathOptimization;

@property (nonatomic, strong, readonly) MPGraph*            graph;
@property (nonatomic, strong, readonly) MPPolygonGeometry*  graphArea;

+ (instancetype _Nullable) newWithDict:(NSDictionary*)dict;
- (instancetype _Nullable) initWithDict:(NSDictionary*)dict;
- (instancetype _Nullable) initWithGraph:(MPGraph*)graph graphArea:(nullable MPPolygonGeometry*)graphArea graphId:(NSString*)graphId;   // Primarily for testing purposes.
- (instancetype) init NS_UNAVAILABLE;

- (MPGraphNode*) getGraphNodeByIndex:(NSUInteger)index;
- (NSArray*) closestNodesInNetworkFromCoordinate: (CLLocationCoordinate2D)coordinate floor: (NSInteger)floor max: (int)max accessTokens:(nullable NSSet<NSString*>*)accessTokens;
- (MPGraphEdge* _Nullable) closestEdgeInGraphFromCoordinate:(CLLocationCoordinate2D)coordinate floor:(NSInteger)floor closestNode:(MPGraphNode*_Nullable*_Nullable)closestNode closestCoordinate:(MPLocationCoordinate3D* _Nullable)closestCoordinate accessTokens:(nullable NSSet<NSString*>*)accessTokens;

- (NSArray<MPGraphNode*>*) findPathFromNode:(MPGraphNode*)startNode toNode:(MPGraphNode*)endNode restrictions:(nullable NSArray<MPHighway*>*)restrictions accessTokens:(nullable NSSet<NSString*>*)accessTokens;
- (NSArray<MPGraphEdge*>*) edgePathFromNodePath:(NSArray<MPGraphNode*>*)nodePath;

@end

NS_ASSUME_NONNULL_END
