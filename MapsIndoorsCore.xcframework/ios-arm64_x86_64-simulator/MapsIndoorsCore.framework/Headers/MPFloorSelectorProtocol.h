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


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@protocol MPFloorSelectorProtocol <NSObject>

/**
  Delegate object to hold the floor change event method.
 */
@required
@property (nonatomic, weak, nullable) id <MPFloorSelectorDelegate> delegate;

/**
  Set floor index.
  @param floor The index of the floor to switch to.
 */
@required
- (void)setFloorIndex:(nullable NSNumber*)floorIndex;

/**
  Update the floor selector based on a building.
  @param building The building that the floor selector should reflect.
 */
@required
- (void) setBuilding:(nullable MPBuilding*)building;

/**
 * Invoked when the SDK indicates to show the floor selector (e.g. a building is present in the viewport)
 */
- (void) onShow;

/**
 * Invoked when the SDK indicates to hide the floor selector (e.g. no buildings are present in the viewport)
 */
- (void) onHide;

/**
 * Removes the floor selector view from its super view (usually the map view)
 */
@required
- (void) remove;

@end

/// > Warning: [INTERNAL - DO NOT USE]
/**
  Delegate protocol specification to hold the floor change event.
 */
@protocol MPFloorSelectorDelegate <NSObject>

/**
  Floor change event method. Must be implemented by delegate object.
 */
@required
- (void) onFloorIndexChanged:(nonnull NSNumber*)floorIndex;

@end



