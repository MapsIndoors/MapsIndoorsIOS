//
//  MPLocationService+Private.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 19/12/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "MPLocationService.h"
#import "MPLocationSourceInternal.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPLocationService (Private) <MPLocationSourceInternal, MPLocationsObserver>

- (void)registerLocationSources:(NSArray<id<MPLocationSource>>*) sources;
- (void)iGetLocationsUsingQuery:(MPQuery *)query filter:(MPFilter *)filter completionHandler:(mpLocationsHandlerBlockType)handler;
- (NSArray<NSArray<MPLocation*>*>*)getLocationsUsingFilters:(NSArray<MPFilter *>*)filters;
- (NSArray<MPLocation*>*)getLocationsUsingFilter:(MPFilter *)filter;
- (void)logSearch:(MPFilter * _Nonnull)filter query:(MPQuery * _Nonnull)query extraParams:(nullable NSDictionary*) extraParams;
@property (nonatomic, readonly, nullable) NSArray<id<MPLocationSource>>* sources;

- (nullable MPMapsIndoorsLocationSource*) defaultLocationSource;

@end


@interface MPLocationService ()

- (void) reinitWithNewSolutionId:(NSString*)solutionId;

@end


NS_ASSUME_NONNULL_END
