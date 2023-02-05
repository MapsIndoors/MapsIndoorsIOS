//
//  MPPathOptimization.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 03/12/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPGraphEdge.h"
#import "MPGraphNode.h"
#import "MPLocation.h"
#import "MPRouteGraphResult.h"
#import "MPRouteLayerService.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, MPPathOptimizationStrategy) {
    MPPathOptimizationStrategy_None = 0,

    MPPathOptimizationStrategy_LineOfSight = 1 << 0,
    MPPathOptimizationStrategy_PreventOvershoot = 1 << 1,
    MPPathOptimizationStrategy_AlwaysOptimize = 1 << 2,                  // Disregard setup in data and always use line-of-sight

    MPPathOptimizationStrategy_LineOfSightWithOvershootPrevention = MPPathOptimizationStrategy_LineOfSight | MPPathOptimizationStrategy_PreventOvershoot,
    MPPathOptimizationStrategy_All = MPPathOptimizationStrategy_LineOfSight | MPPathOptimizationStrategy_PreventOvershoot,
};


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPPathOptimization : NSObject

+ (MPRouteGraphResult*) optimizePath:(NSArray<MPGraphEdge*>*)path nodes:(NSArray<MPGraphNode*>*)nodes obstacles:(MPRouteLayerService*)obstacleService routeNetworkAllowsOptimization:(BOOL)routeNetworkAllowsOptimization;
+ (NSArray<MPLocation*>*) getLocationsFromNodePath:(NSArray<MPGraphNode *> *)nodePath;

@property (nonatomic, class) MPPathOptimizationStrategy    pathOptimizationStrategy;

@end

NS_ASSUME_NONNULL_END
