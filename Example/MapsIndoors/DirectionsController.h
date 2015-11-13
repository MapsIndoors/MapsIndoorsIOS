//
//  DirectionsControllerTableViewController.h
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 13/08/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapsIndoorsSDK/MapsIndoorsSDK.h>
#import "UIFont+SystemFontOverride.h"

@interface DirectionsController : UITableViewController<MPRoutingProviderDelegate>

@property MPRoute* currentRoute;
@property (nonatomic, weak) IBOutlet UIView *tableFooter;


@property (nonatomic, assign) BOOL viewDidAppearCalled;
@property (nonatomic, assign) BOOL viewWillAppearCalled;

-(IBAction) pop;

@end
