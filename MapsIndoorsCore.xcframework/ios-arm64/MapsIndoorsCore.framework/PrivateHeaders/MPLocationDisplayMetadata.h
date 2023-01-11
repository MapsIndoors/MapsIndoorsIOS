//
//  MPLocationDisplayMetadata.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 23/11/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIkit.h>
#import "MapsIndoorsCore/MapsIndoorsCore-Swift.h"


@class MPLocation;
@class MPRouteLeg;
@class MPLocationCluster;
@class MILocationDisplayMetadata;



NS_ASSUME_NONNULL_BEGIN

@interface MPLocationDisplayMetadata : NSObject

@property (nonatomic, strong, readonly, nullable) MPLocation*       location;
@property (nonatomic, strong, nullable) MPRouteLeg*                 routeLeg;
@property (nonatomic, readonly) NSUInteger                          locationTag;
@property (nonatomic) CGPoint                                       markerPoint;
@property (nonatomic, strong, nullable) NSString*                   clusteringId;
@property (nonatomic) NSNumber*                                     displayRank;
@property (nonatomic) CGRect                                        markerImageRect;
@property (nonatomic) CGFloat                                       targetAlpha;

@property (nonatomic, weak, nullable) MPLocationCluster*            cluster;

@property (nonatomic, weak, readonly) MILocationDisplayMetadata*    miLocationDisplayMetadata;

+ (instancetype) newWithTag:(NSUInteger)tag point:(CGPoint)pt rect:(CGRect)rect;
+ (instancetype) newWithLocation:(MPLocation*)location markerPoint:(CGPoint)pt tag:(NSUInteger)tag clusteringId:(NSString*)clusteringId displayRank:(NSNumber*)displayRank;
+ (instancetype) newWithCluster:(MPLocationCluster*)cluster tag:(NSUInteger)tag clusteringId:(NSString*)clusteringId displayRank:(NSNumber*)displayRank;
+ (NSArray<MPLocationDisplayMetadata*>*) metadataWithRouteLeg:(MPRouteLeg*)route tagOffset:(NSUInteger)tagOffset;

@end

NS_ASSUME_NONNULL_END
