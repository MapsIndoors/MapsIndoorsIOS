//
//  MPLocationInternal.h
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
#define MI_BUILDING_ID_PREFIX @"mi_b_"
#define MI_VENUE_ID_PREFIX @"mi_v_"

#import "JSONModel.h"
@import Foundation;
@import MapsIndoors;
@import UIKit;

@class MILocation;
@class MPLiveUpdateInternal;
@class MPLocationUpdate;
@protocol MPLocationFieldInternal;

NS_ASSUME_NONNULL_BEGIN

/**
 This class holds the data for a single location and a marker to display the data on a map.
 */
@interface MPLocationInternal : JSONModel <MPLocation>

/**
 Location id property.
 */
@property (nonatomic, copy) NSString* locationId;

/**
 Location type property.
 */
@property (nonatomic, copy) NSString* type;

/**
 Location venue property. This string correlates with `MPVenue.administrativeId`.
 */
@property (nonatomic, copy, nullable) NSString* venue;
/**
 Location building property. This string correlates with `MPBuilding.administrativeId`.
 */
@property (nonatomic, copy, nullable) NSString* building;
/**
 Location external id property.
 */
@property (nonatomic, copy, nullable) NSString* externalId;

/**
 Location description property.
 */
@property (nonatomic, copy, nullable) NSString* locationDescription;

/**
 Custom properties associated with the location object.
 Keys are case sensitive.  For case-insensitive access to custom properties use -[getPropertyForKey:]
 @sa -[getPropertyForKey:]
 */
@property (nonatomic, copy) NSDictionary<NSString*, id<MPLocationField>><MPLocationFieldInternal>* fields;

/**
 Get data for custom property with key, disregarding casing of key.
 @param key identifier for custom property.
 @return MPLocationField* or nil.
 */
- (nullable id<MPLocationField>)getPropertyForKey:(NSString*)key NS_SWIFT_NAME(getProperty(forKey:));

@property (nonatomic, copy) NSArray<NSString*>* aliases;

/**
 Location name.
 */
@property (nonatomic, copy) NSString* name;

/**
 If the location resides on a specific floor level, this property is set. This value correlates with `MPFloor.zIndex`.
 */
@property (nonatomic, strong) NSNumber* floorIndex;

/**
 If the location resides on a specific floor level, the name of that floor level can be retrieved here.
 */
@property (nonatomic, copy) NSString* floorName;

/**
 The categories for this location, as a dictionary.
 @note This was changed from NSMutableDictionary in SDK v3 to NSMutableArray in SDK v4
 */
@property (nonatomic, copy) NSArray<NSString*>* categories;

/**
 Position as a Lat/Long point.
 */
@property (nonatomic, strong) MPPoint* position;

/**
 URL for image associated with this MPLocation.
 */
@property (nonatomic, copy) NSString* imageURL;

/**
 Location icon. If nil, the location will either get an icon from the settings configured for the type of location or a default appearance that is configurable through `MPMapControl`.
 */
@property (nonatomic, strong, nullable) UIImage* icon;

/**
 Location icon as a URL. If icon is originally set as a UIImage, this property will be ignored.
 */
@property (nonatomic, copy, nullable) NSURL* iconUrl;

/**
 Location base type.
 */
@property (nonatomic) MPLocationBaseType baseType;

/**
If set, location is restricted to given set of app user roles.
*/
@property (nonatomic, copy, nullable) NSArray<NSString*>* restrictions;

@property (nonatomic, nullable) MPGeoBounds* coordinateBounds;

/**
 Get a live property value based on a known key and domain type
 */
- (nullable NSObject*)getLiveValueForKey:(NSString*)key domainType:(NSString*)domainType;

/**
Get a live update based on a known domain type
*/
- (nullable MPLiveUpdateInternal*)getLiveUpdateForDomainType:(NSString*)domainType;

/**
 Determines if the MPLocation is bookable using the MPBookingService.
 */
@property (nonatomic) BOOL isBookable;

// Previously found in MPLocation+Private

- (nullable NSString*) readableLocationIdForBuildingFloor;
/**
 The area in square meters of the outer ring of the locations polygon (if any)
 */
@property (nonatomic, readonly) double area;
/**
 The priority of this location. Used where prioritation is needed to show content on the map.
 */
@property (nonatomic, strong, nullable) NSNumber* priority;
/**
 Key for retrieveing a cached label image.
 */
@property (nonatomic, strong, nullable) NSString* labelCacheKey;
/**
 Parent Location ID
 */
@property (nonatomic, weak, nullable, readonly) id<MPLocation> parentLocation;
/**
 The internal model of Location.
 */
@property (nonatomic, strong, nullable) MILocation* miLocation;
@property (nonatomic, weak, nullable) NSOperation* imageLoadingOperation;
/**
 Will return YES if location is indoors and belongs to a building, otherwise NO.
 */
@property (nonatomic, readonly) BOOL isIndoors;
/**
 Location display rule.
 */
@property (nonatomic, strong, nullable, readwrite) MPDisplayRule* displayRule;
/**
 Location map icon anchor.
 */
@property (nonatomic, nullable) NSValue* iconMapAnchorValue;
@property (nonatomic) CGPoint iconMapAnchor;

/**
Determine internally if a location is configured to be active for a given date.
*/
- (BOOL)isActiveForDate:(NSNumber*)date;
/**
Assign live updates to the location. Live update will be validated for timestamp newer than what is already assigned to the location. If timestamp is older, the live update will be rejected -> not assigned.
*/
- (BOOL)assignLiveUpdate:(MPLiveUpdateInternal*)liveUpdate;

- (instancetype)initWithLocationUpdate:(MPLocationUpdate*) update;

// Previously found in MPMutableLocation

@property (nonatomic, strong, nullable) NSNumber *activeFrom;
@property (nonatomic, strong, nullable) NSNumber *activeTo;
@property (nonatomic, strong, nullable) UIImage *image;
@property (nonatomic, strong) NSString* locationBaseTypeString;

/**
 For internal use only, set byt the ClusterEngine if the MPLocation is part of a cluster.
 */
@property (nonatomic, assign) BOOL isPartOfCluster;

@end

NS_ASSUME_NONNULL_END
