//
//  MPLocationQuery.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 18/03/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPMapExtend.h"
#import "MPPoint.h"

/**
 Locations query mode
 */
typedef enum MPLocationQueryMode {
    MPLocationQueryModeAutocomplete,
    MPLocationQueryModeNormal
} MPLocationQueryMode;

/**
 Locations query object used in conjunction with the MPLocationsProvider
 */
@interface MPLocationQuery : NSObject

/**
 Free text search string
 */
@property (nonatomic, strong) NSString* query;
/**
 Venue filter. Supports the venue key provided in MPVenue.venueKey and MPLocation.venue
 */
@property NSString* venue;
/**
 Building filter. Supports the building key provided in MPLocation.building
 */
@property NSString* building;
/**
 Order by "relevance", "name", "roomId", "venue", "building", "floor". Default is "relevance".
 */
@property NSString* orderBy;
/**
 Apply a sort order. Can either be "asc" or "desc". Default is "asc"
 */
@property NSString* sortOrder;
/**
 Set a reference position coordinate. Distances to this position will affect the relevance of the search results. Only applies when ordering by relevance (default sort order).
 */
@property MPPoint* near;
/**
 Sets a radius limit in meters. Only to be used in conjunction with near property. This will cap the search results to the locations which distance to the near-position is less than specified as radius
 */
@property NSNumber* radius;
/**
 Sets the zoom level. Currently has no effect on the search results.
 */
@property NSNumber* zoomLevel;
/**
 Floor filter. Supports the floor index provided in MPMapControl.currentFloor and MPLocation.floor
 */
@property NSNumber* floor;
/**
 Adds a geographic filter as a bounding box, specified by north, east, south and west
 */
@property MPMapExtend* mapExtend;
/**
 Category filter. Supports the category keys provided from the MPCategoriesProvider. Does not support the localized names of the categories.
 */
@property NSArray* categories;
/**
 Types filter. Supports the type strings provided from the MPSolutionsProvider.
 */
@property NSArray* types;
/**
 Solution id. Mandatory field.
 */
@property NSString* solutionId;
/**
 Previously used for solution id. Now using solutionId as Solution Id
 */
@property NSString* arg;
/**
 Limit the amount of results from the MPLocationsProvider
 */
@property int max;
/**
 Limit the amount of results from the MPLocationsProvider
 */
@property MPLocationQueryMode queryMode;
/**
 Parses an url, identifies query elements and returns a query object
 */
+(MPLocationQuery*) queryWithUrl: (NSURL*) url;

/**
 Query Generation - if the query is reused for multiple searches this will hold the most recent query generation
 */
@property (readonly) NSUInteger        queryGeneration;

@end
