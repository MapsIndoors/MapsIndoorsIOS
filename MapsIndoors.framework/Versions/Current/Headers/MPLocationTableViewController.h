//
//  MPLocationViewController.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 1/22/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPLocation.h"
#import "MPLocationProperty.h"
#import "MPLocationPropertyView.h"

/**
 Location property protocol specification
 */
DEPRECATED_ATTRIBUTE
@protocol MPLocationProperty
@end

/**
 Creates a specialized table view controller, designed to display a locations details.
 */
@interface MPLocationTableViewController : UITableViewController<MPLocationPropertyViewDelegate>

/**
 The location that is to be displayed by the controller.
 */
@property MPLocation* location;
/**
 The data array that will be fed by detail properties from the provided location.
 */
@property NSMutableArray* dataArray;
/**
 The top header view.
 */
@property UIView* headerView;
/**
 The footer view.
 */
@property UIView* footerView;

/**
 Initializes the table view using the provided location.
 */
- (id)initWithLocation:(MPLocation*)location;
/**
 Method that fires whenever a location property is selected.
 */
- (void)locationPropertySelected:(MPLocationProperty*)locationProperty;

@end
