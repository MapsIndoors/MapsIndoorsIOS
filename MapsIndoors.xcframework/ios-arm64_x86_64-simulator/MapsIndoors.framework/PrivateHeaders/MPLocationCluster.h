//
//  MPLocationCluster.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 23/11/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>


@class MPLocationDisplayMetadata;
@class MPLocation;


NS_ASSUME_NONNULL_BEGIN

@interface MPLocationCluster : NSObject

@property (nonatomic, strong, readonly) NSSet<MPLocationDisplayMetadata*>*      objects;
@property (nonatomic, strong, readonly) NSArray<MPLocation*>*                   locations;
@property (nonatomic, strong, readonly) NSSet<NSString*>*                       locationIdsInCluster;
@property (nonatomic, readonly) NSUInteger                                      count;
@property (nonatomic, readonly) CLLocationCoordinate2D                          clusterAnchor;
@property (nonatomic, readonly) CGPoint                                         clusterPosition;    // Screen coordinates
@property (nonatomic) CGSize                                                    clusterSize;        // Screen coordinates
@property (nonatomic, readonly) CGRect                                          clusterRect;        // Screen coordinates
@property (nonatomic, strong, readonly) NSString*                               clusteringId;
@property (nonatomic, readonly) NSInteger                                       displayRank;
@property (nonatomic, readonly) double                                          areaOfClusteredLocations;

- (void) addObject:(MPLocationDisplayMetadata*)object;
- (void) addObjects:(NSArray<MPLocationDisplayMetadata*>*)objects;
- (void) removeObject:(MPLocationDisplayMetadata*)object;
- (void) removeObjects:(NSArray<MPLocationDisplayMetadata*>*)objects;
- (void) unCluster;

@end

NS_ASSUME_NONNULL_END
