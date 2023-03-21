//
//  MPGraphNode.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 23/11/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import "MPLocationCoordinate3D.h"
#import "MPRouteNode.h"
#import "NSString+MPPropertyClassification.h"

NS_ASSUME_NONNULL_BEGIN

@class MINode;
@class MPGraphEdge;
@class MPHighway;
@protocol MPGraphNodePropertyProtocol;

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPGraphNode : NSObject <NSCopying, MPRouteNodeProtocol>

@property (nonatomic, readonly)                   NSUInteger                nodeId;
@property (nonatomic, readonly)                   MPLocationCoordinate3D    coordinate;
@property (nonatomic, readonly)                   NSUInteger                boundary;
@property (nonatomic, readonly, strong, nullable) NSString*                 barrier;
@property (nonatomic, readonly, strong, nullable) NSString*                 floorname;
@property (nonatomic, readonly, strong, nullable) NSString*                 label;
@property (nonatomic, readonly)                   NSTimeInterval            waittime;

@property (nonatomic, readonly)                   MPBoundaryType            boundaryType;
@property (nonatomic, readonly)                   MPBarrierType             barrierType;
@property (nonatomic, readonly)                   BOOL                      isEntryPoint;

@property (nonatomic, readonly, strong, nullable) NSArray<MPGraphEdge*>*    edges;

@property (nonatomic, strong, nullable) NSArray<NSString*>*                restrictions;

@property (nonatomic, readonly, strong)           MINode*                   miNode;

@property (nonatomic, readonly)                   BOOL                      allowPathOptimization;

+ (nullable instancetype) newWithId :(NSUInteger)nodeId coordinate:(MPLocationCoordinate3D)coordinate properties:(id<MPGraphNodePropertyProtocol>)properties label:(NSString* _Nullable)label;
- (nullable instancetype) initWithId:(NSUInteger)nodeId coordinate:(MPLocationCoordinate3D)coordinate properties:(id<MPGraphNodePropertyProtocol>)properties label:(NSString* _Nullable)label;

+ (nullable instancetype) newWithId :(NSUInteger)nodeId coordinate:(MPLocationCoordinate3D)coordinate properties:(id<MPGraphNodePropertyProtocol>)properties label:(NSString* _Nullable)label allowPathOptimization:(BOOL)allowPathOptimization;
- (nullable instancetype) initWithId:(NSUInteger)nodeId coordinate:(MPLocationCoordinate3D)coordinate properties:(id<MPGraphNodePropertyProtocol>)properties label:(NSString* _Nullable)label allowPathOptimization:(BOOL)allowPathOptimization;
- (instancetype) init NS_UNAVAILABLE;

- (BOOL) isEqualToNode:(MPGraphNode*)otherNode;

- (void) addConnectionToNode:(MPGraphNode*)node viaEdge:(MPGraphEdge*)edge;
- (void) removeConnectionToNode:(MPGraphNode*)node;
- (nullable MPGraphEdge*) edgeToNode:(MPGraphNode*)node;

- (BOOL) isAccessibleWithAccessTokens:(nullable NSSet<NSString*>*)accessTokens;

@end


NS_ASSUME_NONNULL_END
