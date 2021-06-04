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
#import "MPLocationField.h"

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
- (void) onBuildingReady: (nonnull NSString*)buildingId;
@end

/**
 Holds relevant data for a single building, and provides a way to interact with the buildings floor levels.
 */
@interface MPBuilding : MPJSONModel
/**
 Holds the current floor.
 */
@property (nonatomic, strong, nullable) NSNumber<Optional>* currentFloor;
/**
 Delegate that holds the building ready event method. Relevant when using offline mode, as it will take a while to load the database upon first app start.
 */
@property (nonatomic, weak, nullable) id <MPBuildingDelegate, Optional> delegate;
/**
 Simple counter that keeps track of how many floors and related tile layers are ready.
 */
@property (nonatomic, strong, nullable) NSNumber<Optional>* floorsReady;
/**
 External id.
 */
@property (nonatomic, strong, nullable) NSString<Optional>* externalId;
@property (nonatomic, strong, nullable) NSString* buildingId;
@property (nonatomic, strong, nullable) NSString<Optional>* administrativeId;
@property (nonatomic, strong, nullable) NSMutableDictionary<NSString*, MPFloor*><MPFloor, Optional>* floors;
@property (nonatomic, strong, nullable) NSString* name;
@property (nonatomic, strong, nullable) MPPoint* anchor;
@property (nonatomic, strong, nullable) NSArray<NSArray*>* bounds;

/**
 Venue id
 */
@property (nonatomic, strong, nullable, readonly) NSString* venueId;

/**
 Get the buildings default floor. Is used by MPMapControl to determine which floor to show if a user have not already selected a floor.
 */
@property (nonatomic, strong, nullable, readonly) NSNumber<Optional>* defaultFloor;
/**
 Dictionary of custom fields
 */
@property (nonatomic, strong, nullable, readonly) NSDictionary<NSString*, MPLocationField*><Optional, MPLocationField> *fields;

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

@end
