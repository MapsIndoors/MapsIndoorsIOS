//
//  Location.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 7/29/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//


#define kLocationPropertyDescription @"description"
#define kLocationPropertyDirections @"directions"
#define kLocationPropertyImage @"image"
#define kLocationPropertyOpeningHours @"openingHours"
#define kLocationPropertyContact @"contact"
#define kLocationPropertyPhone @"phone"
#define kLocationPropertyDate @"date"
#define kLocationPropertyEmail @"email"
#define kLocationPropertyFax @"fax"
#define kLocationPropertyTags @"_tags"
#define kLocationPropertyUrl @"www"
#define kLocationPropertyVideo @"video"

#import <Foundation/Foundation.h>
#import "MPPoint.h"
#import "MPLocationDisplayRuleset.h"
#import "MPLocationProperty.h"
#import "NSDictionary+MPLocationPropertiesDictionary.h"
#import "MPLocationField.h"
#import "MPJSONModel.h"
#import <GoogleMaps/GoogleMaps.h>
@class MPLocationDisplayRuleset;
@class MPLocationDisplayRule;



/**
 This class holds the data for a single location and a marker to display the data on a map.
 */
@interface MPLocation : MPJSONModel
/**
 Location constructor.
 @param  point The geographic point.
 @param  name The name of the location.
 */
- (nullable instancetype) initWithPoint:(nullable MPPoint*)point andName:(nullable NSString*)name DEPRECATED_MSG_ATTRIBUTE("Use MPLocationBuilder instead");
- (nullable instancetype) initWithLocation:(nullable MPLocation*)location DEPRECATED_MSG_ATTRIBUTE("Use MPLocationBuilder instead");
/**
 Location ID string.
 */
@property (nonatomic, strong, nullable, readonly) NSString *locationId;
@property (nonatomic, strong, nullable, readonly) NSString *type;
@property (nonatomic, strong, nullable, readonly) NSNumber<Optional> *activeFrom;
@property (nonatomic, strong, nullable, readonly) NSNumber<Optional> *activeTo;
@property (nonatomic, strong, nullable, readonly) NSString<Optional> *venue;
@property (nonatomic, strong, nullable, readonly) NSString<Optional> *building;
@property (nonatomic, strong, nullable, readonly) NSString<Optional> *roomId;
@property (nonatomic, strong, nullable, readonly) NSString<Optional> *descr;
@property (nonatomic, strong, nullable, readonly) NSDictionary<NSString*, MPLocationField*><Optional, MPLocationField> *fields;
@property (nonatomic, strong, nullable, readonly) NSArray<NSString*><Optional> *aliases;
/**
 Location name.
 */
@property (nonatomic, strong, nullable, readonly) NSString<Optional> *name;
/**
 If the location resides on a specific floor level, this string property is set. 
 */
@property (nonatomic, strong, nullable, readonly) NSNumber* floor;
/**
 The categories for this location, as an array of strings.
 */
@property (nonatomic, strong, nullable, readonly) NSMutableDictionary<Optional> *categories;
/**
 Dictionary of location properties. The keys 'image' and 'description' will always be present, and possibly others, such as 'address', 'contact', 'openinghours' and '_tags' or your own data structure.
 */
@property (nonatomic, strong, nullable, readonly) NSMutableDictionary *properties DEPRECATED_MSG_ATTRIBUTE("Use fields dictionary instead");
/**
 The data type (equals "Feature").
 */
//@property NSString *type;
/**
 Geometry as a Lat/Long point.
 */
@property (nonatomic, strong, nullable, readonly) MPPoint<Ignore> *geometry;
/**
 Marker property used to display on map.
 */
@property (nonatomic, strong, nullable, readonly) GMSMarker<Optional> *marker DEPRECATED_MSG_ATTRIBUTE("Getting a marker from a location is not supported anymore, if you need to change the appearance of a location, create MPDisplaySettings for this");
/**
 Location image. 
 */
@property (nonatomic, strong, nullable, readonly) UIImage<Optional> *image DEPRECATED_MSG_ATTRIBUTE("Use -fields to get properties like image, description etc.");
/**
 Location display rule.
 */
@property (nonatomic, strong, nullable, readonly) MPLocationDisplayRule<Optional> *displayRule DEPRECATED_MSG_ATTRIBUTE("Set display settings on MPMapControl instead.");

/**
 URL for image associated with this MPLocation.
 */
@property (nonatomic, strong, nullable, readonly) NSString<Optional>* imageURL DEPRECATED_MSG_ATTRIBUTE("Use -fields to get properties like image, description etc.");
/**
 Location Source ID. Some implementations have different location sources, and this id is a reference to the location source that created the location. The source ID will remain the same throughout the running application session, but the source ID is not expected to remain the same across sessions.
 */
@property (nonatomic, strong, nullable, readonly) NSNumber<Optional>* sourceId;

/**
 Add the location to a map
 @param  map The map that will hold the marker.
 */
- (void)addToMap:(nonnull GMSMapView*) map DEPRECATED_MSG_ATTRIBUTE("Adding a location to the Google Map directly is not supported any more, use [MapsIndoors registerLocationSources:] instead.");

/**
 Add the location to a map with given display rules.
 @param  map The map that will hold the marker.
 @param  displayRuleset The display ruleset that defines the display of the marker.
   @see MPLocationDisplayRuleset
 */
- (void)addToMap:(nonnull GMSMapView*) map WithRules:(nonnull MPLocationDisplayRuleset*) displayRuleset DEPRECATED_MSG_ATTRIBUTE("Adding a location to a Google Map directly is not supported any more, use [MapsIndoors registerLocationSources:] instead.");

/**
 Add the location to a map with given display rules.
 @param  map The map that will hold the marker.
 @param  floor Floor level.
 @param  displayRuleset The display ruleset that defines the display of the marker.
   @see MPLocationDisplayRuleset
 */
- (void)addToMap:(nonnull GMSMapView*) map floor:(int)floor WithRules:(nonnull MPLocationDisplayRuleset*) displayRuleset DEPRECATED_MSG_ATTRIBUTE("Adding a location to a Google Map directly is not supported any more, use [MapsIndoors registerLocationSources:] instead.");

/**
 Update the location on a map with given display rules.
 @param  map The map that triggered the update.
 @param  displayRuleset The display ruleset that defines the display of the marker.
 @param  floor Floor level.
   @see MPLocationDisplayRuleset
 */
- (void)updateView:(nonnull GMSMapView*) map floor:(int)floor displayRules:(nonnull MPLocationDisplayRuleset*) displayRuleset DEPRECATED_MSG_ATTRIBUTE("Updating a location on a Google Map directly is not supported any more, use [MapsIndoors registerLocationSources:] instead.");
- (void)updateView:(nonnull GMSMapView*) map floor:(int)floor displayRules:(nonnull MPLocationDisplayRuleset*) displayRuleset showAsSearchResult:(BOOL)showAsSearchResult DEPRECATED_MSG_ATTRIBUTE("Updating a location on a Google Map directly is not supported any more, use [MapsIndoors registerLocationSources:] instead.");

/**
 Create a label image with a given text.
 @param  text The text to label with.
 */
- (nullable UIImage*) drawLabel:(nullable NSString*) text DEPRECATED_ATTRIBUTE;

- (void)removeFromMap DEPRECATED_MSG_ATTRIBUTE("Removing a location from a Google Map directly is not supported any more, use [MapsIndoors registerLocationSources:] instead.");
/**
 Set the location image based on information in:
 *
   [self.properties objectForKey:@"image"];
 *
 */
- (void)setImage DEPRECATED_ATTRIBUTE;

/**
 Get the point holding coordinates for the location object
 *
 */
- (nullable MPPoint*)getPoint DEPRECATED_MSG_ATTRIBUTE("Use -getGeometry instead.");

/**
 Get location property of the given type identifier
 *
 */
- (nullable MPLocationProperty*)getProperty:(nullable NSString*)propertyType DEPRECATED_MSG_ATTRIBUTE("Use -getFields instead.");
- (void)showTemporary:(nullable GMSMapView*)map DEPRECATED_ATTRIBUTE;
- (void)hideTemporary DEPRECATED_ATTRIBUTE;
- (void)showDynamically DEPRECATED_ATTRIBUTE;

- (nullable GMSCoordinateBounds*) getCoordinateBounds;

- (BOOL) shouldShowAtZoomLevel:(CGFloat)zLevel usingDisplayRules:(MPLocationDisplayRuleset *_Nullable)displayRules;

@end
