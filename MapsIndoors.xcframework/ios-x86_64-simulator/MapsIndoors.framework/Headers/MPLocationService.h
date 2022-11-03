//
//  MPLocationService.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 06/11/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "MPLocationSourceStatus.h"
#import <Foundation/Foundation.h>

@class MPQuery;
@class MPFilter;
@class MPLocation;

@protocol MPLocationServiceDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 Handler block for a locations query

 @param locations Locations result array
 @param error Error object
 */
typedef void (^mpLocationsHandlerBlockType)(
    NSArray<MPLocation *> *_Nullable locations, NSError *_Nullable error);

/**
 * The `LocationService` acts as service for search and filtering in the full,
 * aggregated collection of Locations. The service requests from all registered
 * Location sources, both internal MapsIndoors and external. Get the shared
 * instance through `MPLocationService.sharedInstance`.
 */
@interface MPLocationService : NSObject

- (instancetype)init NS_UNAVAILABLE;

/**
 * Get the shared instance.
 */
+ (instancetype)sharedInstance;

/**
 * Set a delegate to be informed about the status of loading the locations of
 * the current solution.
 */
@property(nonatomic, weak, nullable) id<MPLocationServiceDelegate> delegate;

/**
 * The current status of the Location Source.
 * The Location Service can not be used reliably until the status is
 * MPLocationSourceStatusComplete.
 */
@property(nonatomic, readonly) MPLocationSourceStatus locationSourceStatus;

/**
 Get locations with given filter, query and callback handler block.

 @param query The query object
 @param filter The filter object
 @param handler The handler block
 */
- (void)getLocationsUsingQuery:(MPQuery *)query
                        filter:(MPFilter *)filter
             completionHandler:(nullable mpLocationsHandlerBlockType)handler;

/**
 * Get the Locations that have the provided external IDs associated.
 * Multiple Locations may have the same external ID associated, so a request with e.g. two external IDs may return more than two Locations.

 @param externalIds The list of external IDs to get Locations for.

 @return An array of Locations that have the requested external IDs. The number of returned Locations may be higher than number of provided external IDs.
 */
- (NSArray<MPLocation*>*)getLocationsByExternalIds:(NSArray<NSString*>*)externalIds;

@end

NS_ASSUME_NONNULL_END
