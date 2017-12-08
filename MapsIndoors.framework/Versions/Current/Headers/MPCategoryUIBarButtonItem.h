//
//  MPCategoryUIBarButtonItem.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 8/2/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 Category button item. Convenient for setting up a menu bar of main categories.
 */
DEPRECATED_ATTRIBUTE
@interface MPCategoryUIBarButtonItem : UIBarButtonItem
/**
 Category for the button.
 */
@property NSString* category;
@end
