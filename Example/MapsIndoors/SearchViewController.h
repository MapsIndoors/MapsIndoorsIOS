//
//  SearchViewController.h
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 10/08/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapsIndoorsSDK/MapsIndoorsSDK.h>
#import "UIFont+SystemFontOverride.h"

@interface SearchViewController : UITableViewController<UISearchResultsUpdating, UISearchBarDelegate>

@property (strong, nonatomic) UISearchController *searchController;

@property (nonatomic, weak) IBOutlet UIView *searchBarContainer;
@property (nonatomic, weak) IBOutlet UIImageView *headerImageView;
@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;

@end
