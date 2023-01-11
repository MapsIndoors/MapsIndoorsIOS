//
//  MPBuilding.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 9/9/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"
#import "MPFloor.h"
#import "MPGeometry.h"
#import "MPPoint.h"
#import "MPBuildingInfo.h"
#import "MPLocationField.h"

@class CoreBounds;
@protocol MPBuilding;
@protocol MPCoordinateBounds;
@protocol MPFloor;
@protocol MPLocationField;

/**
 Holds relevant data for a single building, and the buildings floor levels.
 */
@interface MPBuilding : JSONModel
/**
 Holds the current floor.
 */
@property (nonatomic, strong, nullable, readonly) NSNumber* currentFloor;
/**
 External id.
 */
@property (nonatomic, strong, nullable, readonly) NSString* externalId;
/// Get building id
@property (nonatomic, strong, nullable, readonly) NSString* buildingId;
/// Get building address
@property (nonatomic, strong, nullable, readonly) NSString* address;
/// Get building administrative id
@property (nonatomic, strong, nullable, readonly) NSString* administrativeId;
/// Get building floors
@property (nonatomic, strong, nullable, readonly) NSMutableDictionary<NSString*, MPFloor*><MPFloor>* floors;
/// Get building name
@property (nonatomic, strong, nullable, readonly) NSString* name;
/// Get building anchor coordinate
@property (nonatomic, strong, nullable, readonly) MPPoint* anchor;
/// Get building bounds
@property (nonatomic, strong, nullable, readonly) NSArray<NSArray*>* bounds;

/**
 Venue id
 */
@property (nonatomic, strong, nullable, readonly) NSString* venueId;

/**
 Get the buildings default floor. Is used by MPMapControl to determine which floor to show if a user have not already selected a floor.
 */
@property (nonatomic, strong, nullable, readonly) NSNumber* defaultFloor;
/**
 Dictionary of custom properties
 */
@property (nonatomic, strong, nullable, readonly) NSDictionary<NSString*, MPLocationField*><MPLocationField> *properties;

/**
 Get the floors as an array of MPFloor.
 */
- (nullable NSArray<MPFloor*>*) getFloorArray;
/**
 Get the geographic bounds for the building
 */
- ( CoreBounds* _Nonnull )getBoundingBox;

@end
