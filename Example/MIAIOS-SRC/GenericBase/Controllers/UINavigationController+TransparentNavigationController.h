//
//  UINavigationController+TransparentNavigationController.h
//  MIAIOS
//
//  Created by Daniel Nielsen on 13/08/15.
//  Copyright (c) 2015-2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UINavigationController (TransparentNavigationController)
- (void)presentTransparentNavigationBar;
- (void)hideTransparentNavigationBar;
- (void)resetNavigationBar;
@end
