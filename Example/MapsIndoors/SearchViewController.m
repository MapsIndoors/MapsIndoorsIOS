//
//  SearchViewController.m
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 10/08/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import "SearchViewController.h"
#import "DetailViewController.h"
#import "Global.h"
#import "UINavigationController+TransparentNavigationController.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "UISearchBar+AppSearchBar.h"
#import "POIData.h"


@interface SearchViewController ()

@property NSMutableArray *objects;
@end
@implementation SearchViewController {
    POIData* _locations;
    DetailViewController* _destController;
    UIActivityIndicatorView *_spinner;
    UIView* _tableHeaderView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    _locations = Global.poiData;
    
    _spinner = [[UIActivityIndicatorView alloc]
                initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [[NSNotificationCenter defaultCenter] addObserver:_spinner selector:@selector(startAnimating) name:@"LocationsRequestStarted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocationsReady:) name:@"LocationsDataReady" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    //self.searchController.searchBar.scopeButtonTitles = @[NSLocalizedString(@"ScopeButtonCountry",@"Country"),
    //                                                      NSLocalizedString(@"ScopeButtonCapital",@"Capital")];
    self.searchController.searchBar.delegate = self;
    
    [self.searchController.searchBar setCustomStyle];
    
    
    [self.searchBarContainer addSubview: self.searchController.searchBar];
    
    //Finally since the search view covers the table view when active we make the table view controller define the presentation context:
    
    self.definesPresentationContext = YES;
    
    _spinner.hidesWhenStopped = YES;
    [self.tableView addSubview:_spinner];
    
    self.tableView.contentInset = UIEdgeInsetsMake(-64,0,0,0);
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController presentTransparentNavigationBar];
    if (_locations.locationQuery && _locations.locationQuery.types && Global.solution) {
        for (MPType* type in Global.solution.types) {
            if ([type.name isEqualToString:[_locations.locationQuery.types objectAtIndex:0]]) {
                [self.iconImageView setImageWithURL:[NSURL URLWithString:type.icon] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            }
        }
    }
    self.searchController.searchBar.placeholder = @"Search";
    if (_locations.locationQuery && _locations.locationQuery.types)
        self.searchController.searchBar.placeholder = [NSString stringWithFormat:@"Search %@", [_locations.locationQuery.types firstObject]];
    
    //[self.searchController.searchBar sizeToFit];
    self.searchController.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    
    _spinner.center = CGPointMake(self.view.frame.size.width*0.5, 240);
    
}

- (void)viewWillDisappear:(BOOL)animated {
    //self.searchController.active = NO;
    //self.searchController.searchBar.hidden = YES;
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self performSelector:@selector(focusSearchBar:) withObject:nil afterDelay:0.1];
}

- (void)focusSearchBar:(id)sender {
    [self.searchController.searchBar.window makeKeyAndVisible];
    [self.searchController.searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (self.objects)
        return [self.objects count];
    else return 0;
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"DetailSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MPLocation *object = self.objects[indexPath.row];
        _destController = (DetailViewController *)[segue destinationViewController];
        //_destController.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        //_destController.navigationItem.leftItemsSupplementBackButton = YES;
        [_locations getLocationDetailsAsync:Global.solutionId withId:object.locationId language:@"en"];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchCell" forIndexPath:indexPath];
    
    MPLocation *object = self.objects[indexPath.row];
    cell.textLabel.text = [object name];
    NSString* distText = @"";
    if (Global.positionProvider.latestPositionResult) {
        float dist = [Global.positionProvider.latestPositionResult.geometry distanceTo: [object getPoint]] * 1.2;
        distText = [NSString stringWithFormat:@"   ~ %d m", (int)dist];
    }
    cell.detailTextLabel.text = [NSString stringWithFormat: @"Level %@%@", object.floor, distText];
    
    if (Global.solution) {
        for (MPType* type in Global.solution.types) {
            if ([type.name isEqualToString:object.type]) {
                [cell.imageView setImageWithURL:[NSURL URLWithString:type.icon] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            }
        }
    }

    
    return cell;
}

- (void)onLocationsReady:(NSNotification *)notification {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    [self.objects removeAllObjects];
    [self.objects addObjectsFromArray:notification.object];
    [self.tableView reloadData];
    
    [_spinner stopAnimating];
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if (![_locations.locationQuery.query isEqual:searchController.searchBar.text]) {
        _locations.locationQuery.query = searchController.searchBar.text;
        [_locations getLocationsUsingQueryAsync:_locations.locationQuery language:@"en"];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    //if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [UIView animateWithDuration:0.2 animations:^
         {
             self.tableView.contentInset = UIEdgeInsetsMake(-76,0,0,0);
         }];
    //}
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    
    //Go back to category menu if no types/categories are selected
    //if (_locations.locationQuery.types.count == 0) {
        [_objects removeAllObjects];
        [self.navigationController popViewControllerAnimated:YES];
    //}
}

@end
