//
//  MasterViewController.h
//  MIAIOS
//
//  Created by Daniel Nielsen on 10/08/15.
//  Copyright (c) 2015-2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapsIndoors/MapsIndoors.h>

@import MessageUI;

@class MapViewController;

@interface MasterViewController : UITableViewController<UISearchBarDelegate, MPCategoriesProviderDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) MapViewController *mapViewController;
@property (strong, nonatomic) UITableViewController *detailViewController;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;
@property (nonatomic, weak) IBOutlet UIImageView *headerImageView;
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UIBarButtonItem *venueButtonItem;
@property (weak, nonatomic) IBOutlet UILabel *venueLabel;

@end

