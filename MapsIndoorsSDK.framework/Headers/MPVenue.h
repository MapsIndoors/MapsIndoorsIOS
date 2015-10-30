//
//  MPVenue.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 1/13/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//
#define kDefaultTilesURL "https://mtw-tiles.cloudapp.net/venues/{venueId}/{style}/{buildingId}/{floor}/{z}/{x}/{y}.png"

#import <JSONModel/JSONModel.h>
#import "MPMapStyle.h"
#import "MPPoint.h"

/**
 * Map style protocol specification
 */
@protocol MPMapStyle
@end

/**
 * The venue model holds data about the buildings and floors in a venue, plus additional meta-data.
 */
@interface MPVenue : JSONModel
/**
 * Solution id
 */
@property NSString* solutionId;
/**
 * Venue id
 */
@property NSString* venueId;
/**
 * The general url template to be used when creating floor layers for this venue. If used by this framework, the url string must have format "prefix{param_1}infix{param_N}suffix", e.g.: "http://tiles.url.com/{floor}/{x}/{y}/{zoom}.png". See also MPURITemplate.
 */
@property NSString* tilesUrl;
/**
 * Array of buildings in this venue.
 */
@property NSArray<Optional>* buildings;
/**
 * Array of entry points in this venue.
 */
@property NSArray<Optional, MPPoint>* entryPoints;
/**
 * Route network/graph identifier for the given venue.
 */
@property NSString* graphId;
/**
 * Venue name.
 */
@property NSString* name;
/**
 * Array of possible map styles.
 */
@property NSArray<MPMapStyle>* styles;
/**
 * Get a default style. If none is set, it will be the first string value in the list of map styles
 */
- (NSString*)getDefaultStyle;

@end
