//
//  SearchViewController.h
//  MIAIOS
//
//  Created by Daniel Nielsen on 10/08/15.
//  Copyright (c) 2015-2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapsIndoors/MapsIndoors.h>


@interface SearchViewController : UITableViewController<UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UIButton *backButton;

@property (nonatomic, strong) MPDataField* category;

@end
