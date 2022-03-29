// AUTOGENERATED FILE - DO NOT MODIFY!
// This file generated by Djinni from ClusteringInterface.djinni

#import "MILocationCluster.h"
#import "MILocationDisplayMetadata.h"
#import <Foundation/Foundation.h>
@class MILocationClusteringEngine;
@protocol MILocationClusteringEngineDelegate;


/** The `LocationClusteringEngine` is a clustering/grouping engine based on 2D-spatial overlapping.; */
@interface MILocationClusteringEngine : NSObject

/** Creation/initialiser method.; */
+ (nullable MILocationClusteringEngine *)create;

/** Computes the clusters based on display metadata about locations. Uses the delegate supplied to retrieve cancellations and image sizes.; */
- (nonnull NSArray<MILocationCluster *> *)computeClusters:(nonnull NSArray<MILocationDisplayMetadata *> *)locationsDisplayMetadata
                                                 delegate:(nullable id<MILocationClusteringEngineDelegate>)delegate;

@end