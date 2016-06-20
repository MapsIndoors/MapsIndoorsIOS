//
//  ContainerViewController.h
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 18/08/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFont+SystemFontOverride.h"

@interface ContainerViewController : UIViewController<UISplitViewControllerDelegate>

- (void) setEmbeddedViewController:(UISplitViewController*) splitViewController;

@end
