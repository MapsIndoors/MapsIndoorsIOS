//
//  Location.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 7/29/13.
//  Copyright (c) 2013 MapsPeople A/S. All rights reserved.
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
#import <JSONModel/JSONModel+networking.h>
#import "MPLocationProperty.h"
#import "NSDictionary+MPLocationPropertiesDictionary.h"
#import "MPContactModule.h"
#import "MPLocationField.h"
#ifdef USE_M4B
#import <GoogleMapsM4B/GoogleMaps.h>
#else
#import <GoogleMaps/GoogleMaps.h>
#endif

@class MPLocationDisplayRuleset;
@class MPLocationDisplayRule;



/**
 * This class holds the data for a single location and a marker to display the data on a map.
 */
@interface MPLocation : JSONModel
/**
 * Location constructor.
 * @param point The geographic point.
 * @param name The name of the location.
 */
- (id)initWithPoint:(MPPoint*)point andName:(NSString*)name;
- (id)initWithLocation:(MPLocation*)location;
/**
 * Location ID string.
 */
@property (nonatomic) NSString *locationId;
@property (nonatomic) NSString *type;
@property (nonatomic) NSString<Optional> *venue;
@property (nonatomic) NSString<Optional> *building;
@property (nonatomic) NSString<Optional> *roomId;
@property (nonatomic) NSString<Optional> *descr;
@property (nonatomic) MPContactModule<Optional> *contact;
@property (nonatomic) NSDictionary<MPLocationField, Optional> *fields;
/**
 * Location name.
 */
@property (nonatomic) NSString *name;
/**
 * If the location resides on a specific floor level, this string property is set. 
 */
@property (nonatomic) NSNumber* floor;
/**
 * The categories for this location, as an array of strings.
 */
@property NSMutableDictionary<Optional> *categories;
/**
 * Dictionary of location properties. The keys 'image' and 'description' will allways be present, and possibly others, such as 'address', 'contact', 'openinghours' and '_tags' or your own data structure.
 */
@property NSMutableDictionary *properties;
/**
 * The data type (equals "Feature").
 */
//@property NSString *type;
/**
 * Geometry as a Lat/Long point.
 */
@property (nonatomic) MPPoint *geometry;
/**
 * Marker property used to display on map.
 */
@property GMSMarker<Optional> *marker;
/**
 * Location image. 
 */
@property UIImage<Optional> *image;
/**
 * Location display rule.
 */
@property MPLocationDisplayRule<Optional> *displayRule;

/**
 * Add the location to a map
 * @param map The map that will hold the marker.
 */
- (void)addToMap:(GMSMapView*) map;
/**
 * Add the location to a map with given display rules.
 * @param map The map that will hold the marker.
 * @param displayRuleset The display ruleset that defines the display of the marker.
 * @see MPLocationDisplayRuleset
 */
- (void)addToMap:(GMSMapView*) map WithRules:(MPLocationDisplayRuleset*) displayRuleset;
/**
 * Add the location to a map with given display rules.
 * @param map The map that will hold the marker.
 * @param floor Floor level.
 * @param displayRuleset The display ruleset that defines the display of the marker.
 * @see MPLocationDisplayRuleset
 */
- (void)addToMap:(GMSMapView*) map floor:(int)floor WithRules:(MPLocationDisplayRuleset*) displayRuleset;/**
 * Update the location on a map with given display rules.
 * @param map The map that triggered the update.
 * @param displayRuleset The display ruleset that defines the display of the marker.
 * @param floor Floor level.
 * @see MPLocationDisplayRuleset
 */
- (void)updateView:(GMSMapView*) map floor:(int)floor displayRules:(MPLocationDisplayRuleset*) displayRuleset;
/**
 * Create a label image with a given text.
 * @param text The text to label with.
 */
- (UIImage*) drawLabel:(NSString*) text;
- (void)removeFromMap;
/**
 * Set the location image based on information in:
 *
 * [self.properties objectForKey:@"image"];
 *
 */
- (void)setImage;
/**
 * Get the point holding coordinates for the location object
 *
 */
- (MPPoint*)getPoint;
/**
 * Get location property of the given type identifier
 *
 */
- (MPLocationProperty*)getProperty:(NSString*)propertyType;
- (void)showTemporary:(GMSMapView*)map;
- (void)hideTemporary;
- (void)showDynamically;

@end
