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
- (id)initWithPoint:(MPPoint*)point andName:(NSString*)name;
- (id)initWithLocation:(MPLocation*)location;
/**
 Location ID string.
 */
@property (nonatomic, strong) NSString *locationId;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSNumber<Optional> *activeFrom;
@property (nonatomic, strong) NSNumber<Optional> *activeTo;
@property (nonatomic, strong) NSString<Optional> *venue;
@property (nonatomic, strong) NSString<Optional> *building;
@property (nonatomic, strong) NSString<Optional> *roomId;
@property (nonatomic, strong) NSString<Optional> *descr;
@property (nonatomic, strong) NSDictionary<MPLocationField, Optional> *fields;
@property (nonatomic, strong) NSArray<NSString*><Optional> *aliases;
/**
 Location name.
 */
@property (nonatomic, strong) NSString<Optional> *name;
/**
 If the location resides on a specific floor level, this string property is set. 
 */
@property (nonatomic, strong) NSNumber* floor;
/**
 The categories for this location, as an array of strings.
 */
@property (nonatomic, strong) NSMutableDictionary<Optional> *categories;
/**
 Dictionary of location properties. The keys 'image' and 'description' will always be present, and possibly others, such as 'address', 'contact', 'openinghours' and '_tags' or your own data structure.
 */
@property NSMutableDictionary *properties;
/**
 The data type (equals "Feature").
 */
//@property NSString *type;
/**
 Geometry as a Lat/Long point.
 */
@property (nonatomic) MPPoint<Ignore> *geometry;
/**
 Marker property used to display on map.
 */
@property GMSMarker<Optional> *marker;
/**
 Location image. 
 */
@property UIImage<Optional> *image;
/**
 Location display rule.
 */
@property MPLocationDisplayRule<Optional> *displayRule;

/**
 Add the location to a map
 @param  map The map that will hold the marker.
 */
- (void)addToMap:(GMSMapView*) map;

/**
 Add the location to a map with given display rules.
 @param  map The map that will hold the marker.
 @param  displayRuleset The display ruleset that defines the display of the marker.
   @see MPLocationDisplayRuleset
 */
- (void)addToMap:(GMSMapView*) map WithRules:(MPLocationDisplayRuleset*) displayRuleset;

/**
 Add the location to a map with given display rules.
 @param  map The map that will hold the marker.
 @param  floor Floor level.
 @param  displayRuleset The display ruleset that defines the display of the marker.
   @see MPLocationDisplayRuleset
 */
- (void)addToMap:(GMSMapView*) map floor:(int)floor WithRules:(MPLocationDisplayRuleset*) displayRuleset;

/**
 Update the location on a map with given display rules.
 @param  map The map that triggered the update.
 @param  displayRuleset The display ruleset that defines the display of the marker.
 @param  floor Floor level.
   @see MPLocationDisplayRuleset
 */
- (void)updateView:(GMSMapView*) map floor:(int)floor displayRules:(MPLocationDisplayRuleset*) displayRuleset;

/**
 Create a label image with a given text.
 @param  text The text to label with.
 */
- (UIImage*) drawLabel:(NSString*) text;
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
- (MPPoint*)getPoint;
/**
 Get location property of the given type identifier
 *
 */
- (MPLocationProperty*)getProperty:(NSString*)propertyType;
- (void)showTemporary:(GMSMapView*)map;
- (void)hideTemporary;
- (void)showDynamically;

- (GMSCoordinateBounds*) getCoordinateBounds;

@end
