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

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@protocol MPLocationSourceInternal<NSObject>

/**
 The Locations available from the location source at this point in time
*/
@property (nonnull, nonatomic, readonly) NSArray<MPLocation*>* allLocations;

/**
 Add an observer that gets callbacks about updates, additions and deletions to locations in this location source
 
 @param observer The observer object
 */
//- (void)iAddLocationsObserver:(id<MPLocationsObserver>)observer;

/**
 Remove an observer that gets callbacks about updates, additions and deletions to locations in this location source
 
 @param observer The observer object to remove
 */
//- (void)iRemoveLocationsObserver:(id<MPLocationsObserver>)observer;

/**
 Get the status of the location source:
 .available      available and expected to provide data
 .unavailable    unavailable but expected to provide data under normal circumstances
 .initialising   processing and expected to provide data when initialised
 .inactive       intentionally inactive and not expected to provide data
 
 @return The status of the location source
 */
//- (MPLocationSourceStatus)iStatus;
/**
 Get the id of the location source
 */
//- (NSInteger)iSourceId;

@end

NS_ASSUME_NONNULL_END
