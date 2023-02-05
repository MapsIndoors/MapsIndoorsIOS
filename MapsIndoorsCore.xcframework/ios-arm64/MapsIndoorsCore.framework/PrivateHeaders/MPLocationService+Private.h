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

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPLocationService () <MPLocationSourceInternal, MPLocationsObserver>

@property (nonatomic) NSArray<MPLocation*>* allLocations;
@property (nonatomic, nullable) MPMapsIndoorsLocationSource* defaultLocationSource;

- (void)registerLocationSources:(NSArray<id<MPLocationSource>>*) sources;
- (void)iGetLocationsUsingQuery:(MPQuery *)query filter:(MPFilter *)filter completionHandler:(mpLocationsHandlerBlockType)handler;
- (NSArray<NSArray<MPLocation*>*>*)getLocationsUsingFilters:(NSArray<MPFilter *>*)filters;
- (NSArray<MPLocation*>*)getLocationsUsingFilter:(MPFilter *)filter;
- (void)logSearch:(MPFilter * _Nonnull)filter query:(MPQuery * _Nonnull)query extraParams:(nullable NSDictionary*) extraParams;
- (void) reinitWithNewSolutionId:(NSString*)solutionId;

@end

NS_ASSUME_NONNULL_END
