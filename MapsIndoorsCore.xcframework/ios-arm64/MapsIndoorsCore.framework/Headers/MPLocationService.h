//
//  MPLocationService.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 06/11/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "MPLocationSource.h"

@class MPQuery;
@class MPFilter;
@class MPLocation;


NS_ASSUME_NONNULL_BEGIN


/**
 Handler block for a locations query

 @param locations Locations result array
 @param error Error object
 */
typedef void(^mpLocationsHandlerBlockType)(NSArray<MPLocation*>* _Nullable locations, NSError* _Nullable error);
/**
 Handler block for a single Location query

 @param location Location result object
 @param error Error object
 */
typedef void(^mpSingleLocationHandlerBlockType)(MPLocation* _Nullable location, NSError* _Nullable error);

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 * [DEPRECATED] Use MapsIndoors.shared instance to get or search in data instead.
 *
 * The `LocationService` acts as service for search and filtering in the full, aggregated collection of Locations. The service requests from all registered Location sources, both internal MapsIndoors and external. Get the shared instance through `MPLocationService.sharedInstance`.
 */
@interface MPLocationService : NSObject

- (instancetype)init NS_UNAVAILABLE;
/**
 * Get the shared instance.
 */
+ (instancetype) sharedInstance;

+ (void) shutdown;

/**
 Get locations with given filter, query and callback handler block.

 @param query The query object
 @param filter The filter object
 @param handler The handler block
 */
- (void)getLocationsUsingQuery:(MPQuery*)query filter:(MPFilter*)filter completionHandler:(nullable mpLocationsHandlerBlockType)handler;

/**
 Get Location with given id and callback handler block.

 @param locationId The id of the requested Location
 @param handler The handler block
 */
- (void)getLocationById:(NSString*)locationId completionHandler:(nullable mpSingleLocationHandlerBlockType)handler;

/**
Get a location specified by its id.

 @param locationId The id of the requested Location.
 @returns MPLocation object with the requested location id. Might be nil if the location id does not exist or if the data has not yet been loaded.
 */
- (nullable MPLocation *)getLocationById:(NSString *)locationId;

/**
 Register Location data sources.
 All registered location sources must have a unique sourceId.
 @param sources The sources of Location data to use in the current session.
 */
+ (void)registerLocationSources: (NSArray<id<MPLocationSource>>*) sources;


// SECTION FROM MPLOCATIONSERVICEINTERNAL HEADER
/**
 Add an observer that gets callbacks about updates, additions and deletions to locations in this location source
 
 @param observer The observer object
 */
- (void)iAddLocationsObserver:(id<MPLocationsObserver>)observer;

/**
 Remove an observer that gets callbacks about updates, additions and deletions to locations in this location source
 
 @param observer The observer object to remove
 */
- (void)iRemoveLocationsObserver:(id<MPLocationsObserver>)observer;

/**
 Get the status of the location source:
 .available      available and expected to provide data
 .unavailable    unavailable but expected to provide data under normal circumstances
 .initialising   processing and expected to provide data when initialised
 .inactive       intentionally inactive and not expected to provide data
 
 @return The status of the location source
 */
- (MPLocationSourceStatus)iStatus;
/**
 Get the id of the location source
 */
- (NSInteger)iSourceId;
// -------------------------------------------------


/**
 The currently registered location sources.
*/
@property (class, readonly, nullable) NSArray<id<MPLocationSource>>* sources;

@end

NS_ASSUME_NONNULL_END
