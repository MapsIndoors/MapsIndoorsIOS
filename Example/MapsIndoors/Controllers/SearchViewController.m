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
@import AFNetworking;
#import "UISearchBar+AppSearchBar.h"
#import "POIData.h"
@import VCMaterialDesignIcons;
#import "UIViewController+Custom.h"
#import "MPLocationCell.h"
#import "LocalizedStrings.h"


@interface SearchViewController ()

@property NSMutableArray *objects;
@end
@implementation SearchViewController {
    POIData* _locations;
    DetailViewController* _destController;
    MPVenueProvider* _venueProvider;
    NSArray* _venues;
    NSArray* _buildings;
    UIActivityIndicatorView *_spinner;
    UIView* _tableHeaderView;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    _locations = Global.poiData;
    
    _venueProvider = [[MPVenueProvider alloc] init];
    
    [_venueProvider getVenuesAsync:Global.solutionId language:LocalizationGetLanguage completionHandler:^(MPVenueCollection *venueCollection, NSError *error) {
        if (error == nil) {
            _venues = venueCollection.venues;
            [self.tableView reloadData];
        }
    }];
    
    [_venueProvider getBuildingsAsync:@"all" arg:Global.solutionId language:LocalizationGetLanguage completionHandler:^(NSArray *buildings, NSError *error) {
        if (error == nil) {
            _buildings = buildings;
            [self.tableView reloadData];
        }
    }];
    
     
    _spinner = [[UIActivityIndicatorView alloc]
                initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _spinner.hidesWhenStopped = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:_spinner selector:@selector(startAnimating) name:@"LocationsRequestStarted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocationsReady:) name:@"LocationsDataReady" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"Reload" object:nil];
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
    
    [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

    if (self.headerImageUrl) {
        [self.headerImageView setImageWithURL:[NSURL URLWithString: self.headerImageUrl] placeholderImage:[UIImage imageNamed:@"placeholder1"]];
    }
    
    //Finally since the search view covers the table view when active we make the table view controller define the presentation context:
    
    self.definesPresentationContext = YES;
    
    self.tableView.contentInset = UIEdgeInsetsMake(-64,0,0,0);
    
    [self.tableView addSubview:_spinner];
    
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MPLocationCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LocationCell"];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self presentCustomBackButton];
    
    //[self.navigationController presentTransparentNavigationBar];
    if (_locations.locationQuery && _locations.locationQuery.categories && Global.solution) {
        for (MPType* type in Global.solution.types) {
            if ([type.name isEqualToString:[_locations.locationQuery.categories objectAtIndex:0]]) {
                [self.iconImageView setImageWithURL:[NSURL URLWithString:type.icon] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            }
        }
    }
    self.searchController.searchBar.placeholder = kLangSearch;
    if (_locations.locationQuery && _locations.locationQuery.categories)
        self.searchController.searchBar.placeholder = [NSString stringWithFormat:kLangSearch_var, [_locations.locationQuery.categories firstObject]];
    
    //[self.searchController.searchBar sizeToFit];
    //self.searchController.searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
    
    _spinner.center = CGPointMake(self.view.frame.size.width*0.5, 240);
    [_spinner stopAnimating];
    
    //[self focusSearchBar:nil];
    
}


- (void)viewWillDisappear:(BOOL)animated {
    //self.searchController.active = NO;
    //self.searchController.searchBar.hidden = YES;
    
}

- (void)viewDidAppear:(BOOL)animated {
    //if (_locations.locationQuery.types == nil || _locations.locationQuery.types.count == 0)
        [self performSelector:@selector(focusSearchBar:) withObject:nil afterDelay:0.1];
}

- (void)focusSearchBar:(id)sender {
    [self.searchController.searchBar.window makeKeyAndVisible];
    [self.searchController.searchBar becomeFirstResponder];
    self.searchController.active = YES;
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"DetailSegue" sender:nil];
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"DetailSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MPLocation *object = self.objects[indexPath.row];
        _destController = (DetailViewController *)[segue destinationViewController];
        //_destController.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        //_destController.navigationItem.leftItemsSupplementBackButton = YES;
        [_locations getLocationDetailsAsync:Global.solutionId withId: object.locationId language:LocalizationGetLanguage];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MPLocationCell *cell = (MPLocationCell *)[tableView dequeueReusableCellWithIdentifier:@"LocationCell" forIndexPath:indexPath];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LocationCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    if (indexPath.row < self.objects.count) {
    MPLocation *object = self.objects[indexPath.row];
        cell.textLabel.text = [object name];
        NSString* distText = @"";
        if (Global.positionProvider.latestPositionResult) {
            float dist = [Global.positionProvider.latestPositionResult.geometry distanceTo: [object getPoint]] * 1.2;
            if (dist > 999.999) {
                distText = [NSString stringWithFormat:@"%d km", (int)(dist/1000)];
            } else {
                distText = [NSString stringWithFormat:@"%d m", (int)dist];
            }
        }
        
        cell.distanceLabel.text = distText;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"venueKey LIKE[c] %@", object.venue];
        MPVenue* venue = [[_venues filteredArrayUsingPredicate:predicate] firstObject];
        cell.buildingLabel.text = venue.name;
        
        NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"administrativeId LIKE[c] %@", object.building];
        MPBuilding* building = [[_buildings filteredArrayUsingPredicate:bPredicate] firstObject];
        if (building != nil) {
            cell.floorLabel.hidden = NO;
            cell.floorIcon.hidden = NO;
            
            if (![building.name isEqualToString:venue.name]) {
                cell.buildingLabel.text = [NSString stringWithFormat:@"%@, %@", venue.name, building.name];
            }
            
            [_venueProvider getBuildingDetailsAsync:building.buildingId arg:Global.solutionId language:LocalizationGetLanguage completionHandler:^(MPBuilding *building, NSError *error) {
                if(error == nil) {
                    MPFloor* floor = [building.floors objectForKey:[object.floor stringValue]];
                    cell.floorLabel.text = floor.name;
                }
            }];
        } else {
            cell.floorLabel.hidden = YES;
            cell.floorIcon.hidden = YES;
        }
        
        if (object.displayRule.icon) {
            cell.imageView.image = object.displayRule.icon;
        } else if (object.displayRule.iconPath) {
            [cell.imageView setImageWithURL:[NSURL URLWithString:object.displayRule.iconPath] placeholderImage:[UIImage imageNamed:@"placeholder2"]];
        } else {
            [cell.imageView setImageWithURL:[NSURL URLWithString:[Global getIconUrlForType:object.type]] placeholderImage:[UIImage imageNamed:@"placeholder2"]];
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
        if (_locations.locationQuery.query.length > 0) {
            _locations.locationQuery.orderBy = @"relevance";
        } else {
            _locations.locationQuery.orderBy = @"name";
        }
        [_locations getLocationsUsingQueryAsync:_locations.locationQuery language:LocalizationGetLanguage];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    //if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
    //if (self.tableView.contentInset.top != -76) {
        [UIView animateWithDuration:0.2 animations:^
         {
             self.tableView.contentInset = UIEdgeInsetsMake(-76,0,0,0);
         }];
    //}
    //}
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    UIBarButtonItem* btn = self.splitViewController.displayModeButtonItem;
    [[UIApplication sharedApplication] sendAction:btn.action
                                               to:btn.target
                                             from:nil
                                         forEvent:nil];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    
    //Go back to category menu if no types/categories are selected
    //if (_locations.locationQuery.types.count == 0) {
        [_objects removeAllObjects];
        [self.navigationController popViewControllerAnimated:YES];
    //}
}

@end
