//
//  UIViewController+VenueOpener.h
//  MIAIOS
//
//  Created by Daniel Nielsen on 06/07/16.
//  Copyright © 2017-2018 MapsPeople. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapsIndoors/MapsIndoors.h>

@interface UIViewController (Custom)

- (void) openVenueSelector;
- (void) popToMasterViewControllerAnimated:(BOOL)animated;
- (void) presentCustomBackButton;
- (void) pop;
- (void) toggleSidebar;

@end
