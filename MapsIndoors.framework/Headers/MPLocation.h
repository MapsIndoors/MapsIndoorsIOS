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
- (nullable instancetype) initWithPoint:(nullable MPPoint*)point andName:(nullable NSString*)name;
- (nullable instancetype) initWithLocation:(nullable MPLocation*)location;
/**
 Location ID string.
 */
@property (nonatomic, strong, nullable) NSString *locationId;
@property (nonatomic, strong, nullable) NSString *type;
@property (nonatomic, strong, nullable) NSNumber<Optional> *activeFrom;
@property (nonatomic, strong, nullable) NSNumber<Optional> *activeTo;
@property (nonatomic, strong, nullable) NSString<Optional> *venue;
@property (nonatomic, strong, nullable) NSString<Optional> *building;
@property (nonatomic, strong, nullable) NSString<Optional> *roomId;
@property (nonatomic, strong, nullable) NSString<Optional> *descr;
@property (nonatomic, strong, nullable) NSDictionary<NSString*, MPLocationField*><Optional, MPLocationField> *fields;
@property (nonatomic, strong, nullable) NSArray<NSString*><Optional> *aliases;
/**
 Location name.
 */
@property (nonatomic, strong, nullable) NSString<Optional> *name;
/**
 If the location resides on a specific floor level, this string property is set. 
 */
@property (nonatomic, strong, nullable) NSNumber* floor;
/**
 The categories for this location, as an array of strings.
 */
@property (nonatomic, strong, nullable) NSMutableDictionary<Optional> *categories;
/**
 Dictionary of location properties. The keys 'image' and 'description' will always be present, and possibly others, such as 'address', 'contact', 'openinghours' and '_tags' or your own data structure.
 */
@property (nonatomic, strong, nullable) NSMutableDictionary *properties DEPRECATED_MSG_ATTRIBUTE("Use fields dictionary instead");
/**
 The data type (equals "Feature").
 */
//@property NSString *type;
/**
 Geometry as a Lat/Long point.
 */
@property (nonatomic, strong, nullable) MPPoint *geometry;
/**
 Marker property used to display on map.
 */
@property (nonatomic, strong, nullable) GMSMarker<Optional> *marker;
/**
 Location image. 
 */
@property (nonatomic, strong, nullable) UIImage<Optional> *image;
/**
 Location display rule.
 */
@property (nonatomic, strong, nullable) MPLocationDisplayRule<Optional> *displayRule;

/**
 Add the location to a map
 @param  map The map that will hold the marker.
 */
- (void)addToMap:(nonnull GMSMapView*) map;

/**
 Add the location to a map with given display rules.
 @param  map The map that will hold the marker.
 @param  displayRuleset The display ruleset that defines the display of the marker.
   @see MPLocationDisplayRuleset
 */
- (void)addToMap:(nonnull GMSMapView*) map WithRules:(nonnull MPLocationDisplayRuleset*) displayRuleset;

/**
 Add the location to a map with given display rules.
 @param  map The map that will hold the marker.
 @param  floor Floor level.
 @param  displayRuleset The display ruleset that defines the display of the marker.
   @see MPLocationDisplayRuleset
 */
- (void)addToMap:(nonnull GMSMapView*) map floor:(int)floor WithRules:(nonnull MPLocationDisplayRuleset*) displayRuleset;

/**
 Update the location on a map with given display rules.
 @param  map The map that triggered the update.
 @param  displayRuleset The display ruleset that defines the display of the marker.
 @param  floor Floor level.
   @see MPLocationDisplayRuleset
 */
- (void)updateView:(nonnull GMSMapView*) map floor:(int)floor displayRules:(nonnull MPLocationDisplayRuleset*) displayRuleset;

/**
 Create a label image with a given text.
 @param  text The text to label with.
 */
- (nullable UIImage*) drawLabel:(nullable NSString*) text;

- (void)removeFromMap;
/**
 Set the location image based on information in:
 *
   [self.properties objectForKey:@"image"];
 *
 */
- (void)setImage;

/**
 Get the point holding coordinates for the location object
 *
 */
- (nullable MPPoint*)getPoint;

/**
 Get location property of the given type identifier
 *
 */
- (nullable MPLocationProperty*)getProperty:(nullable NSString*)propertyType;
- (void)showTemporary:(nullable GMSMapView*)map;
- (void)hideTemporary;
- (void)showDynamically;

@end
