//
//  MasterViewController.h
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 10/08/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIFont+SystemFontOverride.h"
#import <MapsIndoorsSDK/MapsIndoorsSDK.h>

@class MapViewController;

@interface MasterViewController : UITableViewController<UISearchBarDelegate, MPCategoriesProviderDelegate>

@property (strong, nonatomic) MapViewController *mapViewController;
@property (strong, nonatomic) UITableViewController *detailViewController;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UIImageView *headerImageView;
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UIButton *venueButton;

@end

