//
//  MPLocationQuery.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 18/03/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPDefines.h"

@class MPMapExtend;
@class MPPoint;


/**
 Locations query mode
 */
typedef NS_ENUM(NSUInteger, MPLocationQueryMode) {
    MPLocationQueryModeAutocomplete,
    MPLocationQueryModeNormal
};

/**
 Locations query object used in conjunction with the MPLocationsProvider
 */
@interface MPLocationQuery : NSObject

/**
 Free text search string
 */
@property (nonatomic, strong, nullable) NSString* query;
/**
 Venue filter. Supports the venue key provided in MPVenue.venueKey and MPLocation.venue
 */
@property (nonatomic, strong, nullable) NSString* venue;
/**
 Building filter. Supports the building key provided in MPLocation.building
 */
@property (nonatomic, strong, nullable) NSString* building;
/**
 Order by "relevance", "name", "roomId", "venue", "building", "floor". Default is "relevance".
 */
@property (nonatomic, strong, nullable) NSString* orderBy;
/**
 Apply a sort order. Can either be "asc" or "desc". Default is "asc"
 */
@property (nonatomic, strong, nullable) NSString* sortOrder;
/**
 Set a reference position coordinate. Distances to this position will affect the relevance of the search results. Only applies when ordering by relevance (default sort order).
 */
@property (nonatomic, strong, nullable) MPPoint* near;
/**
 Sets a radius limit in meters. Only to be used in conjunction with near property. This will cap the search results to the locations which distance to the near-position is less than specified as radius
 */
@property (nonatomic, strong, nullable) NSNumber* radius;
/**
 Sets the zoom level. Currently has no effect on the search results.
 */
@property (nonatomic, strong, nullable) NSNumber* zoomLevel;
/**
 Floor filter. Supports the floor index provided in MPMapControl.currentFloor and MPLocation.floor
 */
@property (nonatomic, strong, nullable) NSNumber* floor;
/**
 Adds a geographic filter as a bounding box, specified by north, east, south and west
 */
@property (nonatomic, strong, nullable) MPMapExtend* mapExtend;
/**
 Category filter. Supports the category keys provided from the MPCategoriesProvider. Does not support the localized names of the categories.
 */
@property (nonatomic, strong, nullable) NSArray<NSString*>* categories;
/**
 Types filter. Supports the type strings provided from the MPSolutionsProvider.
 */
@property (nonatomic, strong, nullable) NSArray<NSString*>* types;
/**
 Solution id. Mandatory field.
 @deprecated
 */
@property (nonatomic, strong, nullable) NSString* solutionId DEPRECATED_MSG_ATTRIBUTE("solutionId is now called contentKey and can only be provided through [MapsIndoors provideAPIKey:apiKey:contentKey]");
/**
 Previously used for solution id. Now using solutionId as Solution Id
 @deprecated
 */
@property (nonatomic, strong, nullable) NSString* arg DEPRECATED_MSG_ATTRIBUTE("arg is now called contentKey and can only be provided through [MapsIndoors provideAPIKey:apiKey:contentKey]");
/**
 Limit the amount of results from the MPLocationsProvider
 */
@property int max;

/**
 Location query mode.  Defaults to MPLocationQueryModeNormal.
 
 The location query mode determines what happens when a MPLocationQuery is re-used, and executed multiple time.
 
 MPLocationQueryModeNormal:
    Results will be delivered for all executions of the query.
 
 MPLocationQueryModeAutocomplete:
    If a query is already executing it will be cancelled when a new query is started.
    This allows starting a query as th euser types, where only the result of the last query is relevant.
 */
@property MPLocationQueryMode queryMode;

/**
 Parses an url, identifies query elements and returns a query object
 */
+(nullable MPLocationQuery*) queryWithUrl: (nonnull NSURL*) url;

/**
 Query Generation - if the query is reused for multiple searches this will hold the most recent query generation
 */
@property (readonly) NSUInteger        queryGeneration;

@end
