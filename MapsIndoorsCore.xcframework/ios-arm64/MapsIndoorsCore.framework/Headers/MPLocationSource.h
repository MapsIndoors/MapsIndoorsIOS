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

@class MPUserRole;

@protocol MPLocationsObserver;

/**
 Location source protocol.
 */
@protocol MPLocationSource<NSObject>
/**
 Get the locations available from the location source at this point in time
 
 @return The list of locations
 */
@required
- (NSArray<MPLocation *> *)getLocations;

/**
 Add an observer that gets callbacks about updates, additions and deletions to locations in this location source

 @param observer The observer object
 */
@required
- (void)addLocationsObserver:(id<MPLocationsObserver>)observer;

/**
 Remove an observer that gets callbacks about updates, additions and deletions to locations in this location source

 @param observer The observer object to remove
 */
@required
- (void)removeLocationsObserver:(id<MPLocationsObserver>)observer;

/**
 Get the status of the location source:
    .available      available and expected to provide data
    .unavailable    unavailable but expected to provide data under normal circumstances
    .initialising   processing and expected to provide data when initialised
    .inactive       intentionally inactive and not expected to provide data

 @return The status of the location source
 */
@required
- (MPLocationSourceStatus)status;
/**
 Get the id of the location source
 */
@required
- (int)sourceId;

@end

@interface MPMapsIndoorsLocationSource : NSObject<MPLocationSource>

+ (BOOL) isOfflineDataAvailableForSolutionId:(NSString*)solutionId language:(NSString*)language;
+ (int) mpMapsIndoorsSourceId;

- (void) synchronizeContentWithCompletion:(void(^_Nullable)(NSError*))completion;

@end

NS_ASSUME_NONNULL_END
