//
//  MPBuilding.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 9/9/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"

@class GMSCoordinateBounds;
@class GMSMapView;
@class MPFloor;
@class MPLocationField;
@class MPPoint;
@protocol MPBuilding;
@protocol MPFloor;
@protocol MPLocationField;

/**
 Delegate protocol that holds the building ready event method. Relevant when using offline mode, as it will take a while to load the database upon first app start.
 */
@protocol MPBuildingDelegate <NSObject>
/**
 Building ready event method. Relevant when using offline mode, as it will take a while to load the database upon first app start. The delegate class must implement onBuildingReady:
 @param buildingId The buildings unique id.
 */
@required
- (void) onBuildingReady: (nonnull NSString*)buildingId;
@end

/**
 Holds relevant data for a single building, and the buildings floor levels.
 */
@interface MPBuilding : JSONModel
/**
 Holds the current floor.
 */
@property (nonatomic, strong, nullable) NSNumber* currentFloor;
/**
 Delegate that holds the building ready event method. Relevant when using offline mode, as it will take a while to load the database upon first app start.
 */
@property (nonatomic, weak, nullable) id <MPBuildingDelegate> delegate;
/**
 Reference to the map. The reference is used to activate/deactivate tile layers.
 */
@property (nonatomic, weak, nullable) GMSMapView* map;
/**
 Simple counter that keeps track of how many floors and related tile layers are ready.
 */
@property (nonatomic, strong, nullable) NSNumber* floorsReady;
/**
 External id.
 */
@property (nonatomic, strong, nullable) NSString* externalId;
/// Get building id
@property (nonatomic, strong, nullable) NSString* buildingId;
/// Get building address
@property (nonatomic, strong, nullable) NSString* address;
/// Get building administrative id
@property (nonatomic, strong, nullable) NSString* administrativeId;
/// Get building floors
@property (nonatomic, strong, nullable) NSMutableDictionary<NSString*, MPFloor*><MPFloor>* floors;
/// Get building name
@property (nonatomic, strong, nullable) NSString* name;
/// Get building anchor coordinate
@property (nonatomic, strong, nullable) MPPoint* anchor;
/// Get building bounds
@property (nonatomic, strong, nullable) NSArray<NSArray*>* bounds;

/**
 Venue id
 */
@property (nonatomic, strong, nullable, readonly) NSString* venueId;

/**
 Get the buildings default floor. Is used by MPMapControl to determine which floor to show if a user have not already selected a floor.
 */
@property (nonatomic, strong, nullable, readonly) NSNumber* defaultFloor;
/**
 Dictionary of custom fields
 */
@property (nonatomic, strong, nullable, readonly) NSDictionary<NSString*, MPLocationField*><MPLocationField> *fields;

/**
 Get the current floor.
 */
- (nullable MPFloor*) getFloor;
/**
 Get the initial/default floor upon creation.
 */
- (nullable NSNumber*) getInitFloor;
/**
 Get the number of floors.
 */
- (nullable NSNumber*) getFloors;
/**
 Get the floors as an array of MPFloor.
 */
- (nullable NSArray<MPFloor*>*) getFloorArray;
/**
 Set the current floor property (without affecting the building display).
 @param  floor The floor number to replace current floor with.
 */
- (void) setFloor: (nullable NSNumber*)floor;
/**
 Use this method to actually shift floor and show the building level.
 @param newFloor The floor number that represents the building level.
 @param map Affected map.
 */
- (void) showBuilding:(nullable NSNumber*) newFloor onMap:(nullable GMSMapView*)map DEPRECATED_ATTRIBUTE;
/**
 Updates the current floor tile layer by clearing the tile cache.
 */
- (void) updateBuildingTiles DEPRECATED_ATTRIBUTE;
/**
 Hide the building from the map.
 */
- (void) hideBuilding DEPRECATED_ATTRIBUTE;
/**
 Get the geographic bounds for the building
 */
- (nullable GMSCoordinateBounds *)getBuildingBounds;

@end
