//
//  MPLocation+Private.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 14/05/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "MPPolygonGeometry.h"
#import "NSObject+GeometryProperties.h"
#import "NSObject+GeoDataStatus.h"
#import "MPLocation.h"
#import "MPLocationUpdate.h"
#import "MILocation.h"
#import "MPLiveUpdate.h"

#define MI_VENUE_ID_PREFIX @"mi_v_"
#define MI_BUILDING_ID_PREFIX @"mi_b_"

NS_ASSUME_NONNULL_BEGIN

@class MPDisplayRule;

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPLocation (Private)


- (nullable NSString*) readableLocationIdForBuildingFloor;

/**
 The area in square meters of the outer ring of the locations polygon (if any)
 */
@property (nonatomic, readonly)                     double                          area;
/**
 The priority of this location. Used where prioritation is needed to show content on the map.
 */
@property (nonatomic, strong, nullable)             NSNumber<Ignore>*               priority;
/**
 Key for retrieveing a cached label image.
 */
@property (nonatomic, strong, nullable)             NSString<Ignore>*               labelCacheKey;

/**
 Parent Location ID
 */
@property (nonatomic, weak, nullable, readonly)     MPLocation*                      parentLocation;

/**
 The internal model of Location.
 */
@property  (nonatomic, strong, nullable)            MILocation<Ignore>*             miLocation;

@property (nonatomic, weak, nullable)               NSOperation<Ignore>*            imageLoadingOperation;
/**
 Location map icon anchor.
 */
@property (nonatomic, readonly)                     CGPoint                         iconMapAnchor;


@end


/// > Warning: [INTERNAL - DO NOT USE]
@interface MPLocation()

- (instancetype)initWithLocationUpdate:(MPLocationUpdate*) update;

/**
 Location map icon anchor.
 */
@property (nonatomic, nullable)                     NSValue<Ignore>*                    iconMapAnchorValue;

@property (nonatomic, readwrite)                    BOOL                                isBookable;     // Writable property internally, primarily to convince JSONModel to deserialize the property...

/**
If set, location is restricted to given set of app user roles.
*/
@property (nonatomic, strong, nullable, readwrite)  NSArray<NSString*>*       restrictions;

/**
Assign live updates to the location. Live update will be validated for timestamp newer than what is already assigned to the location. If timestamp is older, the live update will be rejected -> not assigned.
*/
- (BOOL)assignLiveUpdate:(MPLiveUpdate*)liveUpdate;

/**
Internal iconUrl getter
*/
- (nullable NSURL*)iIconUrl;

/**
Determine internally if a location is configured to be active for a given date.
*/
- (BOOL) isActiveForDate:(NSNumber*)date;

@end

NS_ASSUME_NONNULL_END
