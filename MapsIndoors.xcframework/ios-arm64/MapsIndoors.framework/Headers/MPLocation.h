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

#import "MPJSONModel.h"
#import "MPLocationBaseType.h"
#import <UIKit/UIKit.h>

@class GMSCoordinateBounds;
@class GMSMarker;
@class MPLiveUpdate;
@class MPLocationField;
@class MPLocationProperty;
@class MPPoint;
@protocol MPLocationField;

/**
 This class holds the data for a single location and a marker to display the data on a map.
 */
@interface MPLocation : MPJSONModel
/**
 Location constructor.
 @param  point The geographic point.
 @param  name The name of the location.
 @deprecated Use MPLocationUpdate instead
 */
- (nullable instancetype) initWithPoint:(nullable MPPoint*)point andName:(nullable NSString*)name DEPRECATED_MSG_ATTRIBUTE("Use MPLocationUpdate instead");
/**
 Location constructor.
 @param  location Make a new instance from an existing location.
 @deprecated Use MPLocationUpdate instead
 */- (nullable instancetype) initWithLocation:(nullable MPLocation*)location DEPRECATED_MSG_ATTRIBUTE("Use MPLocationUpdate instead");

/**
 Location id property.
 */
@property (nonatomic, strong, nullable, readonly) NSString *locationId;
/**
 Location type property. This string correlates with `MPType.name`.
 */
@property (nonatomic, strong, nullable, readonly) NSString *type;
/**
 Active from timestamp
 @deprecated
 */
@property (nonatomic, strong, nullable, readonly) NSNumber<Optional> *activeFrom DEPRECATED_ATTRIBUTE;
/**
 Active to timestamp
 @deprecated
 */
@property (nonatomic, strong, nullable, readonly) NSNumber<Optional> *activeTo DEPRECATED_ATTRIBUTE;
/**
 Location venue property. This string correlates with `MPVenue.venueKey`.
 */
@property (nonatomic, strong, nullable, readonly) NSString<Optional> *venue;
/**
 Location building property. This string correlates with `MPBuilding.administrativeId`.
 */
@property (nonatomic, strong, nullable, readonly) NSString<Optional> *building;
/**
 Location room id property.
 @deprecated Use externalId instead
 */
@property (nonatomic, strong, nullable, readonly) NSString<Optional> *roomId DEPRECATED_MSG_ATTRIBUTE("Use externalId instead");
/**
 Location external id property.
 */
@property (nonatomic, strong, nullable, readonly) NSString<Optional> *externalId;
/**
 Location description property.
 */
@property (nonatomic, strong, nullable, readonly) NSString<Optional> *descr;
/**
 Custom properties associated with the location object.
 Keys are case sensitive.  For case-insensitive access to custom properties use @sa -[getFieldForKey:]
 */
@property (nonatomic, strong, nullable, readonly) NSDictionary<NSString*, MPLocationField*><Optional, MPLocationField> *fields;
/**
 Get data for custom property with key, disregarding casing of key.
 @param key identifier for custom property.
 @return MPLocationField* or nil.
 */
- (nullable MPLocationField*) getFieldForKey:(nonnull NSString*)key NS_SWIFT_NAME(getField(forKey:));
/**
 Get aliases for location.
 */
@property (nonatomic, strong, nullable, readonly) NSArray<NSString*> *aliases;
/**
 Location name.
 */
@property (nonatomic, strong, nullable, readonly) NSString *name;
/**
 If the location resides on a specific floor level, this property is set. This value correlates with `MPFloor.zIndex`.
 */
@property (nonatomic, strong, nullable, readonly) NSNumber* floor;
/**
 If the location resides on a specific floor level, the name of that floor level can be retrieved here.
 */
@property (nonatomic, strong, nullable, readonly) NSString* floorName;
/**
 The categories for this location, as a dictionary.
 */
@property (nonatomic, strong, nullable, readonly) NSMutableDictionary *categories;
/**
 Dictionary of location properties. The keys 'image' and 'description' will always be present, and possibly others, such as 'address', 'contact', 'openinghours' and '_tags' or your own data structure.
 @deprecated Use fields dictionary instead
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
@property (nonatomic, strong, nullable, readonly) GMSMarker *marker DEPRECATED_MSG_ATTRIBUTE("Getting a marker from a location is not supported anymore, if you need to change the appearance of a location, create MPDisplaySettings for this");
/**
 Location image. 
 */
@property (nonatomic, strong, nullable, readonly) UIImage *image DEPRECATED_MSG_ATTRIBUTE("Use -fields to get properties like image, description etc.");

/**
 URL for image associated with this MPLocation.
 */
@property (nonatomic, strong, nullable, readonly) NSString* imageURL;
/**
 Location Source ID. Some implementations have different location sources, and this id is a reference to the location source that created the location. The source ID will remain the same throughout the running application session, but the source ID is not expected to remain the same across sessions.
 */
@property (nonatomic, strong, nullable, readonly) NSNumber* sourceId;

/**
 Location icon. If nil, the location will either get an icon from the settings configured for the type of location or a default appearance that is configurable through `MPMapControl`.
 */
@property (nonatomic, strong, nullable, readonly) UIImage*    icon;

/**
 Location icon as a URL. If icon is originally set as a UIImage, this property will be ignored.
 */
@property (nonatomic, strong, nullable, readonly) NSURL*      iconUrl;
/**
 Location base type.
 */
@property (nonatomic, readonly) MPLocationBaseType                      baseType;

/**
If set, location is restricted to given set of app user roles.
*/
@property (nonatomic, strong, nullable, readonly)  NSArray<NSString*>*       restrictions;

/**
 Get the point holding coordinates for the location object
 */
- (nullable MPPoint*)getPoint DEPRECATED_MSG_ATTRIBUTE("Use -getGeometry instead.");

/**
 Get location property of the given type identifier
 */
- (nullable MPLocationProperty*)getProperty:(nullable NSString*)propertyType DEPRECATED_MSG_ATTRIBUTE("Use -getFields instead.");
/**
 Get coordinate bounds for the location object
 */
- (nullable GMSCoordinateBounds*) getCoordinateBounds;
/**
 Get a live property value based on a known key and domain type
 */
- (nullable NSObject*)getLiveValueForKey:(nonnull NSString*)key domainType:(nonnull NSString*)domainType;
/**
Get a live update based on a known domain type
*/
- (nullable MPLiveUpdate*) getLiveUpdateForDomainType:(nonnull NSString*)domainType;

/**
 Will return YES if location is indoors and belongs to a building, otherwise NO.
 */
@property (nonatomic, readonly) BOOL        isIndoors;

/**
 Determines if the MPLocation is bookable using the MPBookingService.
 */
@property (nonatomic, readonly) BOOL        isBookable;

@end
