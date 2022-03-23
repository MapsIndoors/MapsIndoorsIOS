//
//  MPClusterImageRenderer.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 07/12/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MPLocationCluster;


NS_ASSUME_NONNULL_BEGIN

@interface MPClusterImageRenderer : NSObject

+ (UIImage*) imageForCluster:(MPLocationCluster*)cluster;
+ (CGSize) sizeForClusterWithCount:(NSUInteger)count;

@end

NS_ASSUME_NONNULL_END
