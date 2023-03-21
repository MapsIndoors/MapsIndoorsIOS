//
//  MPLocationUpdate.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 29/11/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "MPLocationSource.h"
@import CoreLocation;
@import Foundation;

extern const NSInteger MPLocationUpdateFloorInvalid;


NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Location Update / Builder class
 */
@interface MPLocationUpdate : NSObject


/**
 The id of the Location Source where this location was created
 */
@property (nonatomic, readonly) NSInteger                   sourceId;
/**
 The id of the Location. This id is not unique across multiple location sources.
 */
@property (nonatomic, readonly) NSInteger                   locationId;
/**
 The type of the Location.
 */
@property (nonatomic, strong)   NSString*                   type;
/**
 The name of the Location.
 */
@property (nonatomic, strong)   NSString*                   name;
/**
 The floor index of the Location. Must be set to a valid floor index. If unknown, these can be seen in MapsIndoors CMS.
 */
@property (nonatomic)           NSInteger                   floorIndex;
/**
 The geographical position of the Location.
 */
@property (nonatomic)           CLLocationCoordinate2D      position;
/**
 Location icon. If not set, the location will either get an icon from the settings configured for the type of location or a default appearance that is configurable through `MPMapControl`.
 */
@property (nonatomic, strong, nullable) UIImage*            icon;
/**
 Location icon as a URL. If icon is set as a UIImage, this property will be ignored.
 */
@property (nonatomic, strong, nullable) NSURL*              iconUrl;
/**
 Icon map anchor specifies the point in the icon image that is anchored to the marker's position on the Earth's surface. E.g. point 0.5, 0.5 is the middle of the image.
 */
@property (nonatomic)           CGPoint                     iconMapAnchor;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;


/**
 Initialiser that creates a MPLocationUpdate instance based on an existing location.

 - Parameter location: The existing location.
 - Returns: The updater object.
 */
+ (MPLocationUpdate*) updateWithLocation:(id<MPLocation>) location;

/**
 Initialiser that creates a MPLocationUpdate instance based on an id and a location source.

 - Parameter locationId: Location id. This id is expected to be unique for a given location source, but not necessarily unique across multiple location sources.
 - Parameter locationSource: The location source that is going to maintain this location.
 - Returns: The updater object.
 */
+ (MPLocationUpdate*) updateWithId:(NSInteger)locationId fromSource:(id<MPLocationSource>) locationSource;


/**
 Adds a property to the location update. Some keys will be recognised as a key for a known property on the resulting `MPLocation`. If they are not recognised or the known property only supports one value, the property will be added as a field on `MPLocation.fields`

 - Parameter value: The string value for the property
 - Parameter key: The key for the property
 */
- (void) addPropertyValue: (NSString*) value forKey:(NSString*) key;

/**
 Add category key. Possible categories can be reviewed in MapsIndoors CMS or programmatically using the `MPCategoriesProvider`

 - Parameter categoryKey: The category key
 */
- (void) addCategory: (NSString*) categoryKey;

/**
 Builds the location object. Should only be called once per intended location instance.
 */
- (id<MPLocation>) location;

@end

NS_ASSUME_NONNULL_END
