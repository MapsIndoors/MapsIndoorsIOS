//
//  MPLocationClusteringEngine.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 29/11/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MPLocationDisplayMetadata;
@class MPLocationCluster;
@class MIObjectBoundingboxHittester;
typedef CGSize  (^ClusterSizingBlock)( NSUInteger clusterObjectCount, NSString* _Nonnull clusterId );


NS_ASSUME_NONNULL_BEGIN

@interface MPLocationClusteringEngine : NSObject

@property (nonatomic, strong, readonly) NSArray<MPLocationDisplayMetadata*>*    allLocationDisplayMetadata;
@property (nonatomic, weak, readonly) NSOperation*                              clusteringOperation;        // Cancellation support through this
@property (nonatomic, copy) ClusterSizingBlock                                  clusterSizingBlock;

@property (nonatomic, strong, readonly) NSArray<MPLocationCluster*>*            clusters;

- (NSArray<MPLocationCluster*>*) computeClustersFrom:(NSArray<MPLocationDisplayMetadata*>*)locationsDisplayMetadata
                                 clusteringOperation:(nullable NSOperation*)clusteringOperation;

- (BOOL) debug_checkClusteringResult:(NSMutableString*)report;

@end

NS_ASSUME_NONNULL_END
