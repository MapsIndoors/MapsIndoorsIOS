//
//  MPVenue.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 1/13/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//
#define kDefaultTilesURL "https://mtw-tiles.cloudapp.net/venues/{venueId}/{style}/{buildingId}/{floor}/{z}/{x}/{y}.png"

#import "JSONModel.h"

#import "MPMapStyle.h"
#import "MPPoint.h"
#import "MPBuilding.h"
#import "MPLocationField.h"

/**
 Map style protocol specification
 */
@protocol MPMapStyle;
@protocol MPCoordinateBounds;


/**
 Venue Info
 */
@protocol MPVenueInfo;


/**
 The venue model holds data about the buildings and floors in a venue, plus additional meta-data.
 */
@interface MPVenue : JSONModel
/**
 Solution id
 */
@property (nonatomic, strong, nullable, readonly) NSString* solutionId;
/**
 Venue id
 */
@property (nonatomic, strong, nullable, readonly) NSString* venueId;
/**
 Venue default floor
 */
@property (nonatomic, strong, nullable, readonly) NSNumber* defaultFloor;
/**
 The general url template to be used when creating floor layers for this venue. If used by this framework, the url string must have format "prefix{param_1}infix{param_N}suffix", e.g.: "http://tiles.url.com/{floor}/{x}/{y}/{zoom}.png". See also MPURITemplate.
 */
@property (nonatomic, strong, nullable, readonly) NSString* tilesUrl;
/**
 Container array for buildings in this venue. Note that this array are not populated initially. `MPMapControl` will populate this for the active venue.
 To get the buildings for an arbitrary venue, please use `MPVenueProvider.getBuildingsWithCompletion()`.
 */
@property (nonatomic, strong, nullable, readonly) NSArray<MPBuilding*><MPBuilding, Optional>* buildings;
/**
 Venue anchor point.
 */
@property (nonatomic, strong, nullable, readonly) MPPoint* anchor;
/**
 Geographic BBox array [w,s,e,n] for this venue.
 */
@property (nonatomic, strong, nullable, readonly) NSArray* bbox;
/**
 Geographic bounds array [[lng,lat],[lng,lat],...] for this venue.
 */
@property (nonatomic, strong, nullable, readonly) NSArray<NSArray*>* bounds;
/**
 Array of entry points in this venue.
 */
@property (nonatomic, strong, nullable, readonly) NSArray<MPPoint*><Optional, MPPoint>* entryPoints;
/**
 Route network/graph identifier for the given venue.
 */
@property (nonatomic, strong, nullable, readonly) NSString* graphId;
/**
 Get venue administrative id.
 */
@property (nonatomic, strong, nullable, readonly) NSString* administrativeId;
/**
 External id.
 */
@property (nonatomic, strong, nullable, readonly) NSString* externalId;
/**
 Venue name.
 */
@property (nonatomic, strong, nullable, readonly) NSString* name;
/**
 Array of possible map styles.
 */
@property (nonatomic, strong, nullable, readonly) NSArray<MPMapStyle*><MPMapStyle>* styles;
/**
 Dictionary of custom properties
 */
@property (nonatomic, strong, nullable, readonly) NSDictionary<NSString*, MPLocationField*><Optional, MPLocationField> *properties;
/**
 Get a default style. If none is set, it will be the first string value in the list of map styles
 */
- (nullable MPMapStyle*)getDefaultStyle;
/**
 Get the geographic bounding box for the venue
 */
- ( CoreBounds* _Nonnull )getBoundingBox;
/**
 Does the venue have an active route graph?
 */
@property (nonatomic, readonly) BOOL hasGraph;

@end
