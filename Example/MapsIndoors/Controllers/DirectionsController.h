//
//  DirectionsControllerTableViewController.h
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 13/08/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapsIndoors/MapsIndoors.h>
#import "UIFont+SystemFontOverride.h"
#import "DottedLine.h"
@import MaterialControls;

@interface DirectionsController : UIViewController<MPRoutingProviderDelegate, UITableViewDataSource, UITableViewDelegate>

@property MPRoute* currentRoute;
@property (nonatomic, weak) IBOutlet UIView *tableFooter;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@property (nonatomic, weak) IBOutlet UIButton *originButton;
@property (nonatomic, weak) IBOutlet UIButton *destinationButton;

@property (nonatomic, weak) IBOutlet MDSwitch *avoidStairsSwitch;
@property (nonatomic, weak) IBOutlet UILabel *avoidStairsLabel;
@property (nonatomic, weak) IBOutlet UIView *directionsForm;
@property (nonatomic, weak) IBOutlet DottedLine *line;

@property (nonatomic, weak) IBOutlet UIImageView *originIconView;
@property (nonatomic, weak) IBOutlet UIImageView *destinationIconView;
@property (nonatomic, weak) IBOutlet UIButton *switchDirIconButton;


-(IBAction) pop;

@end
