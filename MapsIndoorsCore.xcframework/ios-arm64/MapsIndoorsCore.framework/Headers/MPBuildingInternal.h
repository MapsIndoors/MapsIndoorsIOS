//
//  MPBuilding.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 9/9/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"
@import MapsIndoors;

@protocol MPFloorInternal;
@protocol MPLocationFieldInternal;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Holds relevant data for a single building, and the buildings floor levels.
 */
@interface MPBuildingInternal : JSONModel <MPBuilding>
/**
 Holds the current floor.
 */
@property (nonatomic, strong, nullable) NSNumber* currentFloor;
/**
 External id.
 */
@property (nonatomic, copy, nullable) NSString* externalId;
/// Get building id
@property (nonatomic, copy, nullable) NSString* buildingId;
/// Get building address
@property (nonatomic, copy, nullable) NSString* address;
/// Get building administrative id
@property (nonatomic, copy, nullable) NSString* administrativeId;
/// Get building floors
@property (nonatomic, copy, nullable) NSMutableDictionary<NSString*, id<MPFloor>><MPFloorInternal>* floors;
/// Get building name
@property (nonatomic, copy, nullable) NSString* name;
/// Get building anchor coordinate
@property (nonatomic, strong, nullable) MPPoint* anchor;
/// Get building bounds
@property (nonatomic, strong, nullable) MPPolygonGeometry* geometry;

@property (nonatomic, strong, nullable) MPEntityInfo* buildingInfo;

/**
 Venue id
 */
@property (nonatomic, copy, nullable) NSString* venueId;

/**
 Get the buildings default floor. Is used by MPMapControl to determine which floor to show if a user have not already selected a floor.
 */
@property (nonatomic, strong, nullable) NSNumber* defaultFloor;
/**
 Dictionary of custom properties
 */
@property (nonatomic, copy, nullable) NSDictionary<NSString*, id<MPLocationField>><MPLocationFieldInternal>* properties;

/**
 Get the geographic bounds for the building
 */
@property (nonatomic, strong, nonnull) MPGeoBounds* boundingBox;

// MPEntity

@property (nonatomic, readonly, strong) MPGeoBounds* entityBounds;
@property (nonatomic, readonly) BOOL entityIsPoint;
@property (nonatomic, readonly, strong) MPPoint* entityPosition;

@end

NS_ASSUME_NONNULL_END
