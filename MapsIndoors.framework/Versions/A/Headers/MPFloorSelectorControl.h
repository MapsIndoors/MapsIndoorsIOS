//
//  MPFloorSelectorControl.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 8/6/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "MPBuilding.h"
#import "MPFloorButton.h"

/**
 * Empty UIButton protocol specification
 */
@protocol MPFloorButton
@end
/**
 * Delegate protocol specification to hold the floor change event.
 */
@protocol MPFloorSelectorDelegate <NSObject>
/**
 * Floor change event method. Must be implemented by delegate object.
 */
@required
- (void) floorHasChanged: (NSNumber*)floorIndex;
@end
/**
 * Floor selection UI element. Can be added to the map, but should be linked to an MPBuilding to make sense.
 */
@interface MPFloorSelectorControl : UIView
/**
 * Get the background color for the selected floor button.
 */
+ (UIColor*) selectedColor;
/**
 * Set the background color for the selected floor button.
 */
+ (void) setSelectedColor:(UIColor*)value;
/**
 * Get the tint color for the floor buttons.
 */
+ (UIColor*) tintColor;
/**
 * Set the tint color for the floor buttons.
 */
+ (void) setTintColor:(UIColor*)value;

/**
 * The current floor.
 */
@property NSNumber* currentFloor;
/**
 * Floor index to start from (typically 0).
 */
@property NSNumber* fromFloorIndex;
/**
 * The number of floors.
 */
@property NSNumber* nFloors;
/**
 * The size of a single floor button (buttonSize x buttonSize).
 */
@property NSNumber* buttonSize;
/**
 * Array of the floor selector buttons.
 */
@property NSMutableArray* buttons;
/**
 * The top icon image.
 */
@property UIImage* topIcon;
/**
 * An outer container view for the buttons.
 */
@property UIView* container;
/**
 * The view holding the floor selector.
 */
@property UIView* parentView;
/**
 * Delegate object to hold the floor change event method.
 */
@property (weak) id <MPFloorSelectorDelegate> delegate;
/**
 * Method that fires when a floor button is pressed.
 * @param sender The button tapped
 */
- (void)notifyFloorSelect:(id)sender;
/**
 * Add the floor selector to a map.
 * @param map The map that should hold the floor selector.
 */
- (void)addToMap:(GMSMapView*)map;
/**
 * Add the floor selector to a view.
 * @param view The view that should hold the floor selector.
 */
- (void)addToView:(UIView*)view;
/**
 * Set floor level.
 * @param floor The floor to switch to.
 */
- (void)setFloor:(NSNumber*)floor;
/**
 * Update the floor selector based on a building.
 * @param building The building that the floor selector should reflect.
 */
- (void)updateFloors:(MPBuilding*)building;
/**
 * Update the floor selector view frame. Needed upon switch to landscape/portrait
 */
- (void)updateFrame;
@end
