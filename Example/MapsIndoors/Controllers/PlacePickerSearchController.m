//
//  PlacePickerSearchController.m
//  MapsIndoors
//
//  Created by Daniel Nielsen on 23/06/16.
//  Copyright © 2016 Daniel Nielsen. All rights reserved.
//

#import "PlacePickerSearchController.h"
#import "Global.h"
#import "UISearchBar+AppSearchBar.h"
#import <MapsIndoors/MapsIndoors.h>
#import "PlacePickerSearchController.h"
#import "UINavigationController+TransparentNavigationController.h"
#import "LocalizationSystem.h"
#import "MPLocationCell.h"
@import AFNetworking;
@import MaterialControls;
@import GoogleMaps;

@interface PlacePickerSearchController ()

@property NSMutableArray *objects;
@end

@implementation PlacePickerSearchController {

    MPLocationsProvider* _locationsProvider;
    MPLocationQuery* _locationQuery;
    UIActivityIndicatorView *_spinner;
    UIView* _tableHeaderView;
    mpLocationSelectBlockType _selectCallback;
    MPVenueProvider* _venueProvider;
    NSArray* _venues;
    NSArray* _buildings;
}

static NSString* cellIdentifier = @"LocationCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _locationsProvider = [[MPLocationsProvider alloc] init];
    _locationQuery = [[MPLocationQuery alloc] init];
    
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
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;

    //self.searchController.searchBar.scopeButtonTitles = @[NSLocalizedString(@"ScopeButtonCountry",@"Country"),
    //                                                      NSLocalizedString(@"ScopeButtonCapital",@"Capital")];
    self.searchController.searchBar.delegate = self;
    
    [self.searchController.searchBar setCustomStyle];
    
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    //Finally since the search view covers the table view when active we make the table view controller define the presentation context:
    
    self.definesPresentationContext = YES;
    
    _spinner.hidesWhenStopped = YES;
    [self.tableView addSubview:_spinner];
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MPLocationCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
    
    [self focusSearchBar:nil];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[self.navigationController presentTransparentNavigationBar];
    
    self.searchController.searchBar.placeholder = @"Search";
    if (_locationQuery && _locationQuery.types)
        self.searchController.searchBar.placeholder = [NSString stringWithFormat:@"Search %@", [_locationQuery.types firstObject]];
    
    //[self.searchController.searchBar sizeToFit];
    //self.searchController.searchBar.frame = CGRectMake(0, 10, self.view.frame.size.width, 54);
    
    _spinner.center = CGPointMake(self.view.frame.size.width*0.5, 240);
    [_spinner stopAnimating];
    
}


- (void)viewWillDisappear:(BOOL)animated {
    //self.searchController.active = NO;
    //self.searchController.searchBar.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    //if (_locations.locationQuery.types == nil || _locations.locationQuery.types.count == 0)
    
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MPLocationCell *cell = (MPLocationCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
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
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name LIKE[c] %@", object.venue];
        MPVenue* venue = [[_venues filteredArrayUsingPredicate:predicate] firstObject];
        cell.buildingLabel.text = venue.name;
        
        NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"administrativeId LIKE[c] %@", object.building];
        MPBuilding* building = [[_buildings filteredArrayUsingPredicate:bPredicate] firstObject];
        if (building) {
            cell.floorLabel.hidden = NO;
            cell.floorIcon.hidden = NO;
            cell.buildingLabel.text = [NSString stringWithFormat:@"%@, %@", venue.name, building.administrativeId];
            
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MPLocation* selectedLocation = [_objects objectAtIndex:indexPath.row];
    if (selectedLocation) {
        if (self.placePickerDelegate) {
            [self.placePickerDelegate onLocationSelected:selectedLocation];
        }
        if (_selectCallback) {
            _selectCallback(selectedLocation);
        }
    }
}

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    if (searchController.searchBar.text.length == 0 && self.myLocation) {
        [self.objects removeAllObjects];
        [self.objects addObject:self.myLocation];
//        [[GMSGeocoder geocoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake([self.myLocation getPoint].lat, [self.myLocation getPoint].lng) completionHandler:^(GMSReverseGeocodeResponse * res, NSError * err) {
//            self.myLocation.descr = res.firstResult.description;
//        }];
        [self.tableView reloadData];
    }
    else if (![_locationQuery.query isEqual:searchController.searchBar.text]) {
        _locationQuery.solutionId = Global.solutionId;
        _locationQuery.query = searchController.searchBar.text;
        _locationQuery.max = 25;
        _locationQuery.orderBy = @"relevance";
        [_locationsProvider getLocationsUsingQueryAsync:_locationQuery language:LocalizationGetLanguage completionHandler:^(MPLocationDataset *locationData, NSError *error) {
            
            if (error) {
                MDSnackbar* bar = [[MDSnackbar alloc] initWithText:@"Failed to get locations" actionTitle:@"" duration:4.0];
                [bar show];
                
            } else {
            
                
                [self.objects removeAllObjects];
                [self.objects addObjectsFromArray:locationData.list];
                [self.tableView reloadData];
                
            }
            
            [_spinner stopAnimating];
        }];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (_objects.count > 0) {
        if (self.placePickerDelegate) {
            [self.placePickerDelegate onLocationSelected:[_objects firstObject]];
        }
        if (_selectCallback) {
            _selectCallback([_objects firstObject]);
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.placePickerDelegate) {
            [self.placePickerDelegate onLocationSelected:nil];
        }
        if (_selectCallback) {
            _selectCallback(nil);
        }
        [_objects removeAllObjects];
    }];
}

- (void) placePickerSelectCallback: (mpLocationSelectBlockType)selectCallbackFn {
    _selectCallback = selectCallbackFn;
}

@end