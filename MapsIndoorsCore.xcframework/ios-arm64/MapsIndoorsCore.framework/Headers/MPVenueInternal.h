//
//  MPVenue.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 1/13/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"
@import MapsIndoors;

@protocol MPBuildingInternal;
@protocol MPLocationFieldInternal;
@protocol MPMapStyleInternal;
@protocol MPPoint;
@protocol MPVenueInfo;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 The venue model holds data about the buildings and floors in a venue, plus additional meta-data.
 */
@interface MPVenueInternal : JSONModel <MPVenue>
/**
 Solution id
 */
@property (nonatomic, copy, nullable) NSString* solutionId;
/**
 Venue id
 */
@property (nonatomic, copy, nullable) NSString* venueId;
/**
 Venue default floor
 */
@property (nonatomic, strong, nullable) NSNumber* defaultFloor;
/**
 The general url template to be used when creating floor layers for this venue. If used by this framework, the url string must have format "prefix{param_1}infix{param_N}suffix", e.g.: "http://tiles.url.com/{floor}/{x}/{y}/{zoom}.png". See also MPURITemplate.
 */
@property (nonatomic, copy, nullable) NSString* tilesUrl;
/**
 Container array for buildings in this venue. Note that this array are not populated initially. `MPMapControl` will populate this for the active venue.
 To get the buildings for an arbitrary venue, please use `MPVenueProvider.getBuildingsWithCompletion()`.
 */
@property (nonatomic, copy, nullable) NSArray<id<MPBuilding>><MPBuildingInternal>* buildings;
/**
 Venue anchor point.
 */
@property (nonatomic, strong, nullable) MPPoint* anchor;
/**
 Geographic bounds array [[lng,lat],[lng,lat],...] for this venue.
 */
@property (nonatomic, strong, nullable) MPPolygonGeometry* geometry;
/**
 Array of entry points in this venue.
 */
@property (nonatomic, copy, nullable) NSArray<MPPoint*><MPPoint>* entryPoints;
/**
 Route network/graph identifier for the given venue.
 */
@property (nonatomic, copy, nullable) NSString* graphId;
/**
 Get venue administrative id.
 */
@property (nonatomic, copy, nullable) NSString* administrativeId;
/**
 External id.
 */
@property (nonatomic, copy, nullable) NSString* externalId;
/**
 Venue name.
 */
@property (nonatomic, copy, nullable) NSString* name;
/**
 Array of possible map styles.
 */
@property (nonatomic, copy, nullable) NSArray<id<MPMapStyle>><MPMapStyleInternal>* styles;
/**
 Dictionary of custom properties
 */
@property (nonatomic, copy, nullable) NSDictionary<NSString*, id<MPLocationField>><MPLocationFieldInternal> *properties;
/**
 Get a default style. If none is set, it will be the first string value in the list of map styles
 */
@property (nonatomic, nullable) id<MPMapStyle> defaultStyle;
/**
 Get the geographic bounding box for the venue
 */
@property (nonatomic) MPGeoBounds* boundingBox;
/**
 Does the venue have an active route graph?
 */
@property (nonatomic) BOOL hasGraph;

@property (nonatomic, strong, nullable) MPEntityInfo* venueInfo;

// Moved from MPVenue+Private

@property (nonatomic, strong, nullable) id<MPMapStyle> mapStyleOverride;
- (id<MPLocation>)getLocation;

// MPEntity

@property (nonatomic, readonly, strong) MPGeoBounds* entityBounds;
@property (nonatomic, readonly) BOOL entityIsPoint;
@property (nonatomic, readonly, strong) MPPoint* entityPosition;

@end

NS_ASSUME_NONNULL_END
