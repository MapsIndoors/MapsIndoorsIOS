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
typedef void(^mpVenueDetailsHandlerBlockType)(MPVenue* venue, NSError* error);

/**
 Handler block for fetching venues.

 @param venueCollection Venue collection. Can be nil.
 @param error Error object. Can be nil.
 */
typedef void(^mpVenueListHandlerBlockType)(MPVenueCollection* venueCollection, NSError* error);

/**
 Handler block for fetching buildings

 @param building Building object. Can be nil.
 @param error Error object. Can be nil.
 */
typedef void(^mpBuildingDetailsHandlerBlockType)(MPBuilding* building, NSError* error);

/**
 Handler block for fetching buildings

 @param buildings Building objects. Can be nil.
 @param error Error object. Can be nil.
 */
typedef void(^mpBuildingListHandlerBlockType)(NSArray<MPBuilding*>* buildings, NSError* error);

/**
 Handler block for fetching data related to a geographic point

 @param venue Building containing the geographic point. Can be nil.
 @param building Building containing the geographic point. Can be nil.
 @param floor Building containing the geographic point. Can be nil.
 @param error Error object. Can be nil.
 */
typedef void(^mpGeocodeHandlerBlockType)(MPVenue* venue, MPBuilding* building, MPFloor* floor, NSError* error);


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
- (void) onVenuesReady: (MPVenueCollection*)venueCollection;
/**
 Building data ready event method.
 @param  building The building data object.
 */
- (void) onBuildingWithinBoundsReady: (MPBuilding*)building;
/**
 Building data ready event method.
 @param  building The building data object.
 */
- (void) onBuildingDetailsReady: (MPBuilding*)building;
/**
 Venue data ready event method.
 @param  venue The venue data object.
 */
- (void) onVenueDetailsReady: (MPVenue*)venue;
/**
 Building data ready event method.
 @param  buildings The buildings data object.
 */
- (void) onBuildingsReady: (NSArray<MPBuilding*>*)buildings;
@end


#pragma mark - MPVenueProvider

/**
 Venue provider interface, that defines a delegate and a method for venue queries.
 */
@interface MPVenueProvider : NSObject
/**
 Venue provider delegate.
 */
@property (weak) id <MPVenueProviderDelegate> delegate;

/**
 Get venues from this provider

 @param arg Solution id
 @param language Language specified with 2-letters (ISO 639-1)
 */
- (void)getVenuesAsync: (NSString*) arg language: (NSString*) language MP_DEPRECATED_MSG_ATTRIBUTE("Use getVenues instead");

/**
 Get a single building within given bounds

 @param mapExtend The geographic bounds, defined by north, south, west and east
 @param solutionId Solution id
 @param language Language specified with 2-letters (ISO 639-1)
 */
- (void)getBuildingWithinBoundsAsync: (MPMapExtend*)mapExtend arg: (NSString*) solutionId language: (NSString*) language MP_DEPRECATED_MSG_ATTRIBUTE("Use getBuildingWithinBounds: instead");

/**
 Get buildings from this provider

 @param venue Venue key as set in MPVenue.venueKey
 @param solutionId Solution id
 @param language Language specified with 2-letters (ISO 639-1)
 */
- (void)getBuildingsAsync: (NSString*)venue arg: (NSString*) solutionId language: (NSString*) language MP_DEPRECATED_MSG_ATTRIBUTE("Use getBuildingsAsync instead");

/**
 Get a single building detail object

 @param buildingId Building id
 @param solutionId Solution id
 @param language Language specified with 2-letters (ISO 639-1)
 */
- (void)getBuildingDetailsAsync: (NSString*)buildingId arg: (NSString*) solutionId language: (NSString*) language MP_DEPRECATED_MSG_ATTRIBUTE("Use getBuildingWithId: instead");

/**
 Get a single venue detail object

 @param venueId Venue id
 @param solutionId Solution id
 @param language Language specified with 2-letters (ISO 639-1)
 */
- (void)getVenueDetailsAsync: (NSString*)venueId arg: (NSString*) solutionId language: (NSString*) language MP_DEPRECATED_MSG_ATTRIBUTE("Use getVenueWithId: instead");

/**
 Get all venues from this provider

 @param arg Solution id
 @param language Language specified with 2-letters (ISO 639-1)
 @param handler Venue fetch callback block
 */
- (void)getVenuesAsync: (NSString*) arg language: (NSString*) language completionHandler:(mpVenueListHandlerBlockType)handler MP_DEPRECATED_MSG_ATTRIBUTE("Use getVenuesWithCompletion: instead");

/**
 Get a single building within given bounds
 
 @param mapExtend The geographic bounds, defined by north, south, west and east
 @param solutionId Solution id
 @param language Language specified with 2-letters (ISO 639-1)
 @param handler Building fetch callback block
 */
- (void)getBuildingWithinBoundsAsync: (MPMapExtend*)mapExtend arg: (NSString*) solutionId language: (NSString*) language completionHandler:(mpBuildingDetailsHandlerBlockType)handler MP_DEPRECATED_MSG_ATTRIBUTE("Use getBuildingWithinBounds:completionHandler: instead");
/**
 Get buildings from this provider
 
 @param venue Venue key as set in MPVenue.venueKey
 @param solutionId Solution id
 @param language Language specified with 2-letters (ISO 639-1)
 @param handler Buildings fetch callback block
 */
- (void)getBuildingsAsync: (NSString*)venue arg: (NSString*) solutionId language: (NSString*) language completionHandler:(mpBuildingListHandlerBlockType)handler MP_DEPRECATED_MSG_ATTRIBUTE("Use getBuildingsWithCompletion: instead");

/**
 Get single building detail object

 @param buildingId Building id
 @param solutionId Solution id
 @param language Language specified with 2-letters (ISO 639-1)
 @param handler Building details fetch callback block
 */
- (void)getBuildingDetailsAsync: (NSString*)buildingId arg: (NSString*) solutionId language: (NSString*) language completionHandler:(mpBuildingDetailsHandlerBlockType)handler MP_DEPRECATED_MSG_ATTRIBUTE("Use getBuildingWithId:completionHandler: instead");

/**
 Get single venue details object

 @param venueId Venue id
 @param solutionId Solution id
 @param language Language specified with 2-letters (ISO 639-1)
 @param handler Venue details fetch callback block
 */
- (void)getVenueDetailsAsync: (NSString*)venueId arg: (NSString*) solutionId language: (NSString*) language completionHandler:(mpVenueDetailsHandlerBlockType)handler MP_DEPRECATED_MSG_ATTRIBUTE("Use getVenueWithId:completionHandler: instead");

/**
 Get all possible data related to the provided geographical point. Callback arguments will be nullable venue, building and floor objects.

 @param point Geographic point
 @param solutionId Solution id
 @param language Language specified with 2-letters (ISO 639-1)
 @param completionHandler Data fetch callback block. Arguments will be nullable venue, building and floor objects.
 */
- (void)getDataFromPointAsync: (MPPoint*)point solutionId: (NSString*) solutionId language: (NSString*) language completionHandler:(mpGeocodeHandlerBlockType)completionHandler MP_DEPRECATED_MSG_ATTRIBUTE("Use getDataFromPoint:completionHandler: instead");
/**
 Synchronously get all possible data related to the provided geographical point. This method will only return data if [MapsIndoors sync:] has processed with success
 
 @param point Geographic point
 @param solutionId Solution id
 @param language Language specified with 2-letters (ISO 639-1)
 @return A dictionary of venue, building and floor objects. Can be empty.
 */
+ (NSDictionary*)getDataFromPoint: (MPPoint*)point solutionId: (NSString*) solutionId language: (NSString*) language MP_DEPRECATED_MSG_ATTRIBUTE("Use getDataFromPoint: instead");




/** V2 Methods **/




/**
 Get venues from this provider
 
 */
- (void)getVenues;

/**
 Get a single building within given bounds
 
 @param mapExtend The geographic bounds, defined by north, south, west and east
 */
- (void)getBuildingWithinBounds: (MPMapExtend*)mapExtend;

/**
 Get buildings from this provider
 
 */
- (void)getBuildings;

/**
 Get a single building detail object
 
 @param buildingId Building id
 */
- (void)getBuildingWithId: (NSString*)buildingId;

/**
 Get a single venue detail object
 
 @param venueId Venue id
 */
- (void)getVenueWithId: (NSString*)venueId;

/**
 Get all venues from this provider
 
 @param handler Venue fetch callback block
 */
- (void)getVenuesWithCompletion:(mpVenueListHandlerBlockType)handler;

/**
 Get a single building within given bounds
 
 @param mapExtend The geographic bounds, defined by north, south, west and east
 @param handler Building fetch callback block
 */
- (void)getBuildingWithinBounds: (MPMapExtend*)mapExtend completionHandler:(mpBuildingDetailsHandlerBlockType)handler;
/**
 Get buildings from this provider
 
 @param handler Buildings fetch callback block
 */
- (void)getBuildingsWithCompletion:(mpBuildingListHandlerBlockType)handler;

/**
 Get single building detail object
 
 @param buildingId Building id
 @param handler Building details fetch callback block
 */
- (void)getBuildingWithId: (NSString*)buildingId completionHandler:(mpBuildingDetailsHandlerBlockType)handler;

/**
 Get single venue details object
 
 @param venueId Venue id
 @param handler Venue details fetch callback block
 */
- (void)getVenueWithId: (NSString*)venueId completionHandler:(mpVenueDetailsHandlerBlockType)handler;

/**
 Get all possible data related to the provided geographical point. Callback arguments will be nullable venue, building and floor objects.
 
 @param point Geographic point
 @param completionHandler Data fetch callback block. Arguments will be nullable venue, building and floor objects.
 */
- (void)getDataFromPoint: (MPPoint*)point completionHandler:(mpGeocodeHandlerBlockType)completionHandler;

/**
 Synchronously get all possible data related to the provided geographical point.
 
 @param point Geographic point
 @return A dictionary of venue, building and floor objects. Can be empty.
 */
+ (NSDictionary*)getDataFromPoint: (MPPoint*)point;

/**
 Determine if cached or preloaded data is available for the given solutionId.
 
 @param solutionId  solutionId to checkfor offline data availability.
 @param language language to check for offline availability.
 @return YES if offline or preloaded data is available, else NO,
 */
+ (BOOL) isOfflineDataAvailableForSolutionId:(NSString*)solutionId language:(NSString*)language;

@end
