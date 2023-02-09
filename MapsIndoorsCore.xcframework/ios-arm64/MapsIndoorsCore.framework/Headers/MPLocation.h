//
//  MPLocation.h
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
#import <UIKit/UIKit.h>
#import "MPPoint.h"
#import "MPLocationProperty.h"
#import "MPLocationField.h"
#import "JSONModel.h"
#import "MPLocationBaseType.h"

#import "MPLiveUpdate.h"

@class MPDisplayRule;
@class CoreBounds;
@protocol MPLocationField;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 This class holds the data for a single location and a marker to display the data on a map.
 */
@interface MPLocation : JSONModel

/**
 Location display rule.
 */
@property (nonatomic, strong, nullable, readwrite) MPDisplayRule<Optional>* displayRule;

/**
 Location id property.
 */
@property (nonatomic, strong, readonly) NSString* locationId;

/**
 Location type property.
 */
@property (nonatomic, strong, readonly) NSString* type;

/**
 Location venue property. This string correlates with `MPVenue.administrativeId`.
 */
@property (nonatomic, strong, nullable, readonly) NSString<Optional>* venue;
/**
 Location building property. This string correlates with `MPBuilding.administrativeId`.
 */
@property (nonatomic, strong, nullable, readonly) NSString<Optional>* building;
/**
 Location external id property.
 */
@property (nonatomic, strong, nullable, readonly) NSString<Optional>* externalId;

/**
 Location description property.
 */
@property (nonatomic, strong, nullable, readonly) NSString<Optional>* locationDescription;

/**
 Will return YES if location is indoors and belongs to a building, otherwise NO.
 */
@property (nonatomic, readonly) BOOL        isIndoors;

/**
 Custom properties associated with the location object.
 Keys are case sensitive.  For case-insensitive access to custom properties use ``getPropertyForKey:``
 */
@property (nonatomic, strong, readonly) NSDictionary<NSString*, MPLocationField*><Optional, MPLocationField>* properties;

/**
 Get data for custom property with key, disregarding casing of key.
 - Parameter key: identifier for custom property.
 - Returns: MPLocationField* or nil.
 */
- (nullable MPLocationField*) getPropertyForKey:(NSString*)key NS_SWIFT_NAME(getProperty(forKey:));

@property (nonatomic, strong, readonly) NSArray<NSString*>* aliases;

/**
 Location name.
 */
@property (nonatomic, strong, readonly) NSString* name;

/**
 If the location resides on a specific floor level, this property is set. This value correlates with `MPFloor.zIndex`.
 */
@property (nonatomic, strong, readonly) NSNumber* floorIndex;

/**
 If the location resides on a specific floor level, the name of that floor level can be retrieved here.
 */
@property (nonatomic, strong, readonly) NSString* floorName;

/**
 The categories for this location, as a dictionary.
 @note This was changed from NSMutableDictionary in SDK v3 to NSMutableArray in SDK v4
 */
@property (nonatomic, strong, readonly) NSArray<NSString*>* categories;

/**
 Position as a Lat/Long point.
 */
@property (nonatomic, strong, readonly) MPPoint<Ignore>* position;

/**
 URL for image associated with this MPLocation.
 */
@property (nonatomic, strong, nullable, readonly) NSString* imageURL;

/**
 Location icon. If nil, the location will either get an icon from the settings configured for the type of location or a default appearance that is configurable through `MPMapControl`.
 */
@property (nonatomic, strong, nullable, readonly) UIImage* icon;

/**
 Location icon as a URL. If icon is originally set as a UIImage, this property will be ignored.
 */
@property (nonatomic, strong, nullable, readonly) NSURL* iconUrl;

/**
 Location base type.
 */
@property (nonatomic, readonly) MPLocationBaseType baseType;

/**
If set, location is restricted to given set of app user roles.
*/
@property (nonatomic, strong, nullable, readonly) NSArray<NSString*>* restrictions;

- (nullable CoreBounds*)getCoordinateBounds;

/**
 Get a live property value based on a known key and domain type
 */
- (nullable NSObject*)getLiveValueForKey:(NSString*)key domainType:(NSString*)domainType;

/**
Get a live update based on a known domain type
*/
- (nullable MPLiveUpdate*)getLiveUpdateForDomainType:(NSString*)domainType;

/**
 Determines if the MPLocation is bookable using the MPBookingService.
 */
@property (nonatomic, readonly) BOOL isBookable;

/**
 For internal use only, set byt the ClusterEngine if the MPLocation is part of a cluster.
 */
@property (nonatomic, assign) BOOL isPartOfCluster;
@end

NS_ASSUME_NONNULL_END
