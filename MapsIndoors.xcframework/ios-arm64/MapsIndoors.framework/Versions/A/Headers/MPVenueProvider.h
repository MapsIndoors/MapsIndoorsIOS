//
//  MPVenueProvider.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 1/14/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPDefines.h"


@class MPVenueCollection;
@class MPBuilding;
@class MPVenue;
@class MPMapExtend;
@class MPFloor;
@class MPPoint;
@class MPMapExtend;


#pragma mark - typedefs
/**
 Handler block for fetching venues.

 @param venue Venue object. Can be nil.
 @param error Error object. Can be nil.
 */
typedef void(^mpVenueDetailsHandlerBlockType)(MPVenue* _Nullable venue, NSError* _Nullable error);

/**
 Handler block for fetching venues.

 @param venueCollection Venue collection. Can be nil.
 @param error Error object. Can be nil.
 */
typedef void(^mpVenueListHandlerBlockType)(MPVenueCollection* _Nullable venueCollection, NSError* _Nullable error);

/**
 Handler block for fetching buildings

 @param building Building object. Can be nil.
 @param error Error object. Can be nil.
 */
typedef void(^mpBuildingDetailsHandlerBlockType)(MPBuilding* _Nullable building, NSError* _Nullable error);

/**
 Handler block for fetching buildings

 @param buildings Building objects. Can be nil.
 @param error Error object. Can be nil.
 */
typedef void(^mpBuildingListHandlerBlockType)(NSArray<MPBuilding*>* _Nullable buildings, NSError* _Nullable error);

/**
 Handler block for fetching data related to a geographic point

 @param venue Building containing the geographic point. Can be nil.
 @param building Building containing the geographic point. Can be nil.
 @param floor Building containing the geographic point. Can be nil.
 @param error Error object. Can be nil.
 */
typedef void(^mpGeocodeHandlerBlockType)(MPVenue* _Nullable venue, MPBuilding* _Nullable building, MPFloor* _Nullable floor, NSError* _Nullable error);


#pragma mark - MPVenueProviderDelegate

/**
 Venue provider delegate.
 */
@protocol MPVenueProviderDelegate <NSObject>
/**
 Venue data ready event method.
 @param  venueCollection The venue data collection.
 */
@required
/**
 Venue data ready event method.
 @param  venueCollection The venue data collection.
 */
- (void) onVenuesReady: (nonnull MPVenueCollection*)venueCollection;
/**
 Building data ready event method.
 @param  building The building data object.
 */
- (void) onBuildingWithinBoundsReady: (nonnull MPBuilding*)building;
/**
 Building data ready event method.
 @param  building The building data object.
 */
- (void) onBuildingDetailsReady: (nonnull MPBuilding*)building;
/**
 Venue data ready event method.
 @param  venue The venue data object.
 */
- (void) onVenueDetailsReady: (nonnull MPVenue*)venue;
/**
 Building data ready event method.
 @param  buildings The buildings data object.
 */
- (void) onBuildingsReady: (nonnull NSArray<MPBuilding*>*)buildings;
@end


#pragma mark - MPVenueProvider

/**
 Venue provider interface, that defines a delegate and a method for venue queries.
 */
@interface MPVenueProvider : NSObject
/**
 Venue provider delegate.
 */
@property (nonatomic, weak, nullable) id <MPVenueProviderDelegate> delegate;

/**
 Get venues from this provider
 
 */
- (void)getVenues;

/**
 Get a single building within given bounds
 
 @param mapExtend The geographic bounds, defined by north, south, west and east
 */
- (void)getBuildingWithinBounds: (nonnull MPMapExtend*)mapExtend;

/**
 Get buildings from this provider
 
 */
- (void)getBuildings;

/**
 Get a single building detail object
 
 @param buildingId Building id
 */
- (void)getBuildingWithId: (nonnull NSString*)buildingId;

/**
 Get a single venue object
 
 @param venueId Venue id
 */
- (void)getVenueWithId: (nonnull NSString*)venueId;

/**
 Get all venues from this provider
 
 @param handler Venue fetch callback block
 */
- (void)getVenuesWithCompletion:(nullable mpVenueListHandlerBlockType)handler;

/**
 Get a single building within given bounds
 
 @param mapExtend The geographic bounds, defined by north, south, west and east
 @param handler Building fetch callback block
 */
- (void)getBuildingWithinBounds: (nonnull MPMapExtend*)mapExtend completionHandler:(nullable mpBuildingDetailsHandlerBlockType)handler;
/**
 Get buildings from this provider
 
 @param handler Buildings fetch callback block
 */
- (void)getBuildingsWithCompletion:(nullable mpBuildingListHandlerBlockType)handler;

/**
 Get single building detail object
 
 @param buildingId Building id
 @param handler Building details fetch callback block
 */
- (void)getBuildingWithId: (nonnull NSString*)buildingId completionHandler:(nullable mpBuildingDetailsHandlerBlockType)handler;

/**
 Get single venue details object
 
 @param venueId Venue id
 @param handler Venue details fetch callback block
 */
- (void)getVenueWithId: (nonnull NSString*)venueId completionHandler:(nullable mpVenueDetailsHandlerBlockType)handler;

/**
 Get all possible data related to the provided geographical point. Callback arguments will be nullable venue, building and floor objects.
 
 @param point Geographic point
 @param completionHandler Data fetch callback block. Arguments will be nullable venue, building and floor objects.
 */
- (void)getDataFromPoint: (nonnull MPPoint*)point completionHandler:(nullable mpGeocodeHandlerBlockType)completionHandler;

/**
 Synchronously get all possible data related to the provided geographical point.
 
 @param point Geographic point
 @return A dictionary of venue, building and floor objects. Can be empty.
 */
+ (nullable NSDictionary*)getDataFromPoint: (nonnull MPPoint*)point;

/**
 Determine if cached or preloaded data is available for the given solutionId.
 
 @param solutionId  solutionId to checkfor offline data availability.
 @param language language to check for offline availability.
 @return YES if offline or preloaded data is available, else NO,
 */
+ (BOOL) isOfflineDataAvailableForSolutionId:(nonnull NSString*)solutionId language:(nonnull NSString*)language;

@end
