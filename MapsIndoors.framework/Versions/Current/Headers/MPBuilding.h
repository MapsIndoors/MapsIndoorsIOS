//
//  MPBuilding.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 9/9/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import "MPJSONModel.h"
#import "MPFloor.h"
#import "MPGeometry.h"
#import "MPPoint.h"
#import "MPBuildingInfo.h"

#import <GoogleMaps/GoogleMaps.h>

@protocol MPBuilding
@end

@protocol MPFloor
@end

/**
 Delegate protocol that holds the building ready event method. Relevant when using offline mode, as it will take a while to load the database upon first app start.
 */
@protocol MPBuildingDelegate <NSObject>
/**
 Building ready event method. Relevant when using offline mode, as it will take a while to load the database upon first app start. The delegate class must implement onBuildingReady:
 @param  shortName The buildings unique shortname.
 */
@required
- (void) onBuildingReady: (NSString*)buildingId;
@end
/**
 Holds relevant data for a single building, and provides a way to interact with the buildings floor levels.
 */
@interface MPBuilding : MPJSONModel
/**
 Holds the current floor.
 */
@property (nonatomic)NSNumber<Optional>* currentFloor;
/**
 Delegate that holds the building ready event method. Relevant when using offline mode, as it will take a while to load the database upon first app start.
 */
@property (weak) id <MPBuildingDelegate, Optional> delegate;
/**
 Reference to the map. The reference is used to activate/deactivate tile layers.
 */
@property (nonatomic)GMSMapView<Optional>* map;
/**
 Simple counter that keeps track of how many floors and related tile layers are ready.
 */
@property NSNumber<Optional>* floorsReady;

@property NSString* buildingId;
@property NSString* administrativeId;
@property NSMutableDictionary<NSString*, MPFloor*><MPFloor, Optional>* floors;
@property NSString* name;
@property MPPoint* anchor;
@property NSArray<NSArray*>* bounds;

/**
 Get the current floor.
 */
- (MPFloor*) getFloor;
/**
 Get the initial/default floor upon creation.
 */
- (NSNumber*) getInitFloor;
/**
 Get the number of floors.
 */
- (NSNumber*) getFloors;
/**
 Get the floors as an array of MPFloor.
 */
- (NSArray*) getFloorArray;
/**
 Set the current floor property (without affecting the building display).
 @param  floor The floor number to replace current floor with.
 */
- (void) setFloor: (NSNumber*)floor;
/**
 Use this method to actually shift floor and show the building level.
 @param newFloor The floor number that represents the building level.
 @param map Affected map.
 */
- (void) showBuilding:(NSNumber*) newFloor onMap:(GMSMapView*)map DEPRECATED_ATTRIBUTE;
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
- (GMSCoordinateBounds *)getBuildingBounds;
/**
 Get the geographic outline for the building
 */
//- (GMSPolygon *)getPolygon;

@end
