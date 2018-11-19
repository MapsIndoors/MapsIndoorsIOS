//
//  MPLocationSource.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 26/10/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPLocation.h"
#import "MPLocationSourceStatus.h"
#import "MPLocationsObserver.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MPLocationsObserver;

@protocol MPLocationSource<NSObject>
/**
 Get the locations available from the location source at this point in time
 
 @return The list of locations
 */
- (nonnull NSArray<MPLocation *> *)getAllLocations;

/**
 Add an observer that gets callbacks about updates, additions and deletions to locations in this location source

 @param observer The observer object
 */
- (void)addLocationObserver:(id<MPLocationsObserver>)observer;

/**
 Remove an observer that gets callbacks about updates, additions and deletions to locations in this location source

 @param observer The observer object to remove
 */
- (void)removeLocationObserver:(id<MPLocationsObserver>)observer;

/**
 Get the status of the location source:
    .available      available and expected to provide data
    .unavailable    unavailable but expected to provide data under normal circumstances
    .initialising   processing and expected to provide data when initialised
    .inactive       intentionally inactive and not expected to provide data

 @return The status of the location source
 */
- (MPLocationSourceStatus)sourceStatus;

@end

@interface MPMapsIndoorsLocationSource : NSObject<MPLocationSource>

+ (BOOL) isOfflineDataAvailableForSolutionId:(NSString*)solutionId language:(NSString*)language;

@end

NS_ASSUME_NONNULL_END
