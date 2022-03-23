//
//  MPFloorSelectorProtocol.h
//  MapsIndoorsSDK
//
//  Created by Michael Bech Hansen on 05/05/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MPBuilding;
@protocol MPFloorSelectorDelegate;


@protocol MPFloorSelectorProtocol <NSObject>

/**
  Delegate object to hold the floor change event method.
 */
@required
@property (nonatomic, weak, nullable) id <MPFloorSelectorDelegate> delegate;

/**
  Set floor level.
  @param floor The floor to switch to.
 */
@required
- (void) setFloor:(nullable NSNumber*)floor;

/**
  Update the floor selector based on a building.
  @param building The building that the floor selector should reflect.
 */
@required
- (void) updateFloors:(nullable MPBuilding*)building;

/**
 *
 */
@required
- (void) deactivate;

@end


/**
  Delegate protocol specification to hold the floor change event.
 */
@protocol MPFloorSelectorDelegate <NSObject>

/**
  Floor change event method. Must be implemented by delegate object.
 */
@required
- (void) floorHasChanged:(nonnull NSNumber*)floorIndex;

@end



