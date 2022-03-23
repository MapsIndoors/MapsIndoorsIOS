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
#import "MPBuilding.h"
#import "MPLocationField.h"
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
@property (nonatomic, strong, nullable) NSString<Optional>* solutionId;
/**
 Venue id
 */
@property (nonatomic, strong, nullable) NSString* venueId;
/**
 Venue default floor
 */
@property (nonatomic, strong, nullable) NSNumber<Optional>* defaultFloor;
/**
 The general url template to be used when creating floor layers for this venue. If used by this framework, the url string must have format "prefix{param_1}infix{param_N}suffix", e.g.: "http://tiles.url.com/{floor}/{x}/{y}/{zoom}.png". See also MPURITemplate.
 */
@property (nonatomic, strong, nullable) NSString* tilesUrl;
/**
 Container array for buildings in this venue. Note that this array are not populated initially. `MPMapControl` will populate this for the active venue.
 To get the buildings for an arbitrary venue, please use `MPVenueProvider.getBuildingsWithCompletion()`.
 */
@property (nonatomic, strong, nullable) NSArray<MPBuilding*><MPBuilding, Optional>* buildings;
/**
 Venue anchor point.
 */
@property (nonatomic, strong, nullable) MPPoint<Optional>* anchor;
/**
 Geographic BBox array [w,s,e,n] for this venue.
 */
@property (nonatomic, strong, nullable) NSArray<Optional>* bbox;
/**
 Geographic bounds array [[lng,lat],[lng,lat],...] for this venue.
 */
@property (nonatomic, strong, nullable) NSArray<NSArray*>* bounds;
/**
 Array of entry points in this venue.
 */
@property (nonatomic, strong, nullable) NSArray<MPPoint*><Optional, MPPoint>* entryPoints;
/**
 Route network/graph identifier for the given venue.
 */
@property (nonatomic, strong, nullable) NSString<Optional>* graphId;
/**
 Venue key.
 */
@property (nonatomic, strong, nullable) NSString<Optional>* venueKey;
/**
 External id.
 */
@property (nonatomic, strong, nullable) NSString<Optional>* externalId;
/**
 Venue name.
 */
@property (nonatomic, strong, nullable) NSString<Optional>* name;
/**
 Array of possible map styles.
 */
@property (nonatomic, strong, nullable) NSArray<MPMapStyle*><MPMapStyle>* styles;
/**
 Dictionary of custom fields
 */
@property (nonatomic, strong, nullable, readonly) NSDictionary<NSString*, MPLocationField*><Optional, MPLocationField> *fields;
/**
 Get a default style. If none is set, it will be the first string value in the list of map styles
 */
- (nullable MPMapStyle*)getDefaultStyle;
/**
 Get the geographic bounding box for the venue
 */
- (nullable GMSCoordinateBounds *)getBoundingBox;
/**
 Get the geographic bounds for the venue
 @deprecated
 */
- (nullable GMSCoordinateBounds *)getVenueBounds DEPRECATED_MSG_ATTRIBUTE("Use getBoundingBox");
/**
 YES/NO property - determines of venue has _graphId
 */
@property (nonatomic, readonly) BOOL hasGraph;

@end
