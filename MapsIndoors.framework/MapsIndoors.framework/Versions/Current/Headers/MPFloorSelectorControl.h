//
//  MPFloorSelectorControl.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 8/6/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "MPFloorButton.h"
#import "MPFloorSelectorProtocol.h"


/**
  Empty UIButton protocol specification
 */
@protocol MPFloorButton
@end


/**
  Floor selection UI element. Can be added to the map, but should be linked to an MPBuilding to make sense.
 */
@interface MPFloorSelectorControl : UIView <MPFloorSelectorProtocol>

/**
  Get the background color for the selected floor button.
 */
+ (UIColor*) selectedColor;

/**
  Set the background color for the selected floor button.
 */
+ (void) setSelectedColor:(UIColor*)value;

/**
  Get the tint color for the floor buttons.
 */
+ (UIColor*) tintColor;

/**
  Set the tint color for the floor buttons.
 */
+ (void) setTintColor:(UIColor*)value;

/**
 *  The textColor of floor selector buttons in normal state.
 */
@property (class) UIColor*       floorButtonTitleColor;

/**
 *  The textColor of floor selector buttons in selected state.
 */
@property (class) UIColor*       selectedFloorButtonTitleColor;

/**
 *  The backgroundColor of floor selector buttons in normal state.
 */
@property (class) UIColor*       floorButtonBackgroundColor;

/**
 *  The backgroundColor of floor selector buttons in selected state.
 */
@property (class) UIColor*       selectedFloorButtonBackgroundColor;

/**
 *  The padding around floor selector buttons.  Defaults to 1.
 */
@property (class) NSInteger      floorButtonBorderPadding;

/**
 * The current floor.
 */
@property NSNumber* currentFloor;

/**
  Floor index to start from (typically 0).
 */
@property NSNumber* fromFloorIndex;

/**
  The number of floors.
 */
@property NSNumber* nFloors;

/**
  The size of a single floor button (buttonSize x buttonSize).
 */
@property NSNumber* buttonSize;

/**
  Array of the floor selector buttons.
 */
@property NSMutableArray* buttons;

/**
  The top icon image.
 */
@property UIImage* topIcon;

/**
  UIImageView containing the top image.
 */
@property (nonatomic, weak, readonly) UIImageView*  topImageView;

/**
  An outer container view for the buttons.
 */
@property UIView* container;

/**
  The view holding the floor selector.
 */
@property UIView* parentView;

/**
  Method that fires when a floor button is pressed.
  @param sender The button tapped
 */
- (void)notifyFloorSelect:(id)sender;

/**
  Add the floor selector to a map.
  @param map The map that should hold the floor selector.
 */
- (void)addToMap:(GMSMapView*)map;

/**
  Add the floor selector to a view.
  @param view The view that should hold the floor selector.
 */
- (void)addToView:(UIView*)view;

/**
  Update the floor selector view frame. Needed upon switch to landscape/portrait
 */
- (void)updateFrame;

/**
   The maximum height that the floor selector may occupy
 */
@property (nonatomic) CGFloat   maxHeight;

/**
 *
 */
@property (nonatomic) BOOL   disableAutomaticLayoutManagement;

@end
