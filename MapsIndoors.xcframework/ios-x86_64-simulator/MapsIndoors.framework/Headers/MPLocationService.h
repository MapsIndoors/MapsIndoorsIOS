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
- (void)getLocationsUsingQuery:(nonnull MPQuery *)query
                        filter:(nonnull MPFilter *)filter
             completionHandler:(nullable mpLocationsHandlerBlockType)handler;

@end

NS_ASSUME_NONNULL_END
