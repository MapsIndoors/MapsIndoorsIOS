//
//  MPVenue.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 1/13/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//
#define kDefaultTilesURL "https://mtw-tiles.cloudapp.net/venues/{venueId}/{style}/{buildingId}/{floor}/{z}/{x}/{y}.png"

#import "MPJSONModel.h"
#import <GoogleMaps/GoogleMaps.h>
#import "MPMapStyle.h"
#import "MPPoint.h"

/**
 Map style protocol specification
 */
@protocol MPMapStyle
@end

/**
 Venue Info
 */
@protocol MPVenueInfo
@end

/**
 The venue model holds data about the buildings and floors in a venue, plus additional meta-data.
 */
@interface MPVenue : MPJSONModel
/**
 Solution id
 */
@property NSString<Optional>* solutionId;
/**
 Venue id
 */
@property NSString* venueId;
/**
 Venue default floor
 */
@property NSNumber<Optional>* defaultFloor;
/**
 The general url template to be used when creating floor layers for this venue. If used by this framework, the url string must have format "prefix{param_1}infix{param_N}suffix", e.g.: "http://tiles.url.com/{floor}/{x}/{y}/{zoom}.png". See also MPURITemplate.
 */
@property NSString* tilesUrl;
/**
 Array of buildings in this venue.
 */
@property NSArray<Optional>* buildings;
/**
 Venue anchor point.
 */
@property MPPoint<Optional>* anchor;
/**
 Geographic BBox array [w,s,e,n] for this venue.
 */
@property NSArray<Optional>* bbox;
/**
 Geographic bounds array [[lng,lat],[lng,lat],...] for this venue.
 */
@property NSArray<NSArray*>* bounds;
/**
 Array of entry points in this venue.
 */
@property NSArray<Optional, MPPoint>* entryPoints;
/**
 Route network/graph identifier for the given venue.
 */
@property NSString* graphId;
/**
 Venue key.
 */
@property (nonatomic, strong) NSString<Optional>* venueKey;
/**
 Venue name.
 */
@property NSString<Optional>* name;
/**
 Array of possible map styles.
 */
@property NSArray<MPMapStyle>* styles;
/**
 Get a default style. If none is set, it will be the first string value in the list of map styles
 */
- (NSString*)getDefaultStyle;
/**
 Get the geographic bounding box for the venue
 */
- (GMSCoordinateBounds *)getBoundingBox;
/**
 Get the geographic bounds for the venue
 */
- (GMSCoordinateBounds *)getVenueBounds;

@end
