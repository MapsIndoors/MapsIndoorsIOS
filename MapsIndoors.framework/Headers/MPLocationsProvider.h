//
//  MPLocationsProvider.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 1/14/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPDefines.h"


@class MPLocationDataset;
@class MPLocationQuery;
@class MPLocation;


typedef void(^mpLocationDetailsHandlerBlockType)(MPLocation* _Nullable location, NSError* _Nullable error);
typedef void(^mpLocationListHandlerBlockType)(MPLocationDataset* _Nullable locationData, NSError* _Nullable error);

/**
 Locations provider delegate.
 */
@protocol MPLocationsProviderDelegate <NSObject>
/**
 Locations data ready event method.
 @param locationData The Locations data collection.
 */
@required
- (void) onLocationsReady: (nonnull MPLocationDataset*)locationData;
/**
 Locations details ready event method.
 @param location The Location detail object.
 */
@required
- (void) onLocationDetailsReady: (nonnull MPLocation*)location;
@end


/**
 Locations provider protocol.
 */
@protocol MPLocationsProvider <NSObject>

@property (nonatomic, weak, nullable) id <MPLocationsProviderDelegate> delegate;

/**
 Method to initiate fetching of all locations from the provider in a specific translation.
 @deprecated Use getLocations instead
 @param  solutionId The MapsIndoors solution ID.
 @param  language The language code. Must be one of the MapsIndoors solutions supported content languages.
 */
- (void)getLocationsAsync: (nonnull NSString*) solutionId language: (nonnull NSString*) language DEPRECATED_MSG_ATTRIBUTE("Use getLocations instead");

/**
 Method to initiate fetching of all locations from the provider in the current transation ([MapsIndoors getLanguage]).
 */
- (void)getLocations;

/**
 Method to initiate fetching of all locations from the provider in a specific translation.
 @deprecated Use getLocationsWithCompletion instead
 @param  solutionId The MapsIndoors solution ID.
 @param  language The language code. Must be one of the MapsIndoors solutions supported content languages.
 @param  handler The handler callback block. Contains the MPLocation object (can be nil) and an NSError object (can be nil).
 */
- (void)getLocationsAsync: (nonnull NSString*) solutionId language: (nonnull NSString*) language completionHandler: (nullable mpLocationListHandlerBlockType) handler MP_DEPRECATED_MSG_ATTRIBUTE("Use getLocationsWithCompletion instead");

/**
 Method to initiate fetching of all locations from the provider in the current transation ([MapsIndoors getLanguage]).
 @param  handler The handler callback block. Contains the MPLocation object (can be nil) and an NSError object (can be nil).
 */
- (void)getLocationsWithCompletion: (nullable mpLocationListHandlerBlockType) handler;

/**
 Method to query a unique location from the provider based on an id.
 @deprecated Use getLocationWithId instead
 @param  solutionId The MapsIndoors solution ID.
 @param  locationId The MapsIndoors location ID.
 @param  language The language code. Must be one of the MapsIndoors solutions supported content languages.
 */
- (void)getLocationDetailsAsync: (nonnull NSString*) solutionId withId:(nonnull NSString*)locationId language: (nonnull NSString*) language MP_DEPRECATED_MSG_ATTRIBUTE("Use getLocationWithId: instead");

/**
 Method to query a unique location from the provider based on an id.
 Data is returned in the current transation ([MapsIndoors getLanguage]).
 @param  locationId The MapsIndoors location ID.
 */
- (void)getLocationWithId:(nonnull NSString*)locationId;

/**
 Method to query a unique location from the provider based on an id.
 @deprecated Use getLocationWithId:completionHandler: instead
 @param  solutionId The MapsIndoors solution ID.
 @param  locationId The MapsIndoors location ID.
 @param  language The language code. Must be one of the MapsIndoors solutions supported content languages.
 @param  handler The handler callback block. Contains the MPLocation object (can be nil) and an NSError object (can be nil).
 */
- (void)getLocationDetailsAsync: (nonnull NSString*) solutionId withId:(nonnull NSString*)locationId language: (nonnull NSString*) language completionHandler: (nullable mpLocationDetailsHandlerBlockType) handler MP_DEPRECATED_MSG_ATTRIBUTE("Use getLocationWithId:completionHandler: instead");

/**
 Method to query a unique location from the provider based on an id.
 Data is returned in the current transation ([MapsIndoors getLanguage]).
 @param  locationId The MapsIndoors location ID.
 */
@required
- (void)getLocationWithId:(nonnull NSString*)locationId completionHandler:(nullable mpLocationDetailsHandlerBlockType) handler;

/**
 Method to query a subset of locations from the provider.
 @deprecated Use getLocationsUsingQuery: instead
 @param  locationQuery Locations query object. Must at least define your MapsIndoors solution ID (MPLocationQuery.solutionId)
 @param  language The language code. Must be one of the MapsIndoors solutions supported content languages.
 */
- (void)getLocationsUsingQueryAsync: (nonnull MPLocationQuery*) locationQuery language: (nonnull NSString*) language MP_DEPRECATED_MSG_ATTRIBUTE("Use getLocationsUsingQuery: instead");

/**
 Determine if cached or preloaded data is available for the given solutionId.
 
 @param solutionId  SolutionId to check for offline data availability.
 @param language Language to check for offline data availability.
 @return YES if offline or preloaded data is available, else NO,
 */
+ (BOOL) isOfflineDataAvailableForSolutionId:(nonnull NSString*)solutionId language:(nonnull NSString*)language;

/**
 Method to query a subset of locations from the provider.
 Data is returned in the current transation ([MapsIndoors getLanguage]).
 @param  locationQuery Locations query object. Must at least define your MapsIndoors solution ID (MPLocationQuery.solutionId)
 */
- (void)getLocationsUsingQuery:(nonnull MPLocationQuery*) locationQuery;

/**
 Method to query a subset of locations from the provider.
 @deprecated Use getLocationsUsingQuery:completionHandler: instead
 @param locationQuery Locations query object. Must at least define your MapsIndoors solution ID (MPLocationQuery.solutionId)
 @param language The language code. Must be one of the MapsIndoors solutions supported content languages.
 @param handler The handler callback block. Contains the MPLocationDataset object (can be nil) and an NSError object (can be nil).
 */
- (void)getLocationsUsingQueryAsync: (nonnull MPLocationQuery*) locationQuery language: (nonnull NSString*) language completionHandler: (nullable mpLocationListHandlerBlockType) handler MP_DEPRECATED_MSG_ATTRIBUTE("Use getLocationsUsingQuery:completionHandler: instead");

/**
 Method to query a subset of locations from the provider.
 Data is returned in the current translation ([MapsIndoors getLanguage]).
 @param locationQuery Locations query object. Must at least define your MapsIndoors solution ID (MPLocationQuery.solutionId)
 @param handler The handler callback block. Contains the MPLocationDataset object (can be nil) and an NSError object (can be nil).
 */
- (void)getLocationsUsingQuery:(nonnull MPLocationQuery*)locationQuery completionHandler:(nullable mpLocationListHandlerBlockType)handler;

@end


/**
 Locations provider that defines a delegate and a method to initiate fetching of locations from the provider.
 */
@interface MPLocationsProvider : NSObject<MPLocationsProvider>

@end
