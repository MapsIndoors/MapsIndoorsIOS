//
//  UINavigationController+TransparentNavigationController.h
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 13/08/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFont+SystemFontOverride.h"

@interface UINavigationController (TransparentNavigationController)
- (void)presentTransparentNavigationBar;
- (void)hideTransparentNavigationBar;
- (void)resetNavigationBar;
@end