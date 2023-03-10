//
//  MPDataSetCacheWorkScheduler.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 05/03/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MPDataSetCacheTask;


NS_ASSUME_NONNULL_BEGIN

@interface MPDataSetCacheWorkScheduler : NSObject

@property (nonatomic, readonly) BOOL        started;
@property (nonatomic, readonly) NSUInteger  count;

- (void) start;
- (void) stop;

- (BOOL) addWorkItems:(NSArray<MPDataSetCacheTask*>*)workItems;
- (BOOL) addWorkItems:(NSArray<MPDataSetCacheTask*>*)workItems includeDependencies:(BOOL)includeDependencies;
- (BOOL) removeWorkItems:(NSArray<MPDataSetCacheTask*>*)workItems;
- (void) cancelTasksWithOwner:(id)owner;

@end

NS_ASSUME_NONNULL_END
