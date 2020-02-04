//
//  SearchViewController.m
//  MIAIOS
//
//  Created by Daniel Nielsen on 10/08/15.
//  Copyright (c) 2015-2018 MapsPeople A/S. All rights reserved.
//

#import "SearchViewController.h"
#import "DetailViewController.h"
#import "Global.h"
#import "UINavigationController+TransparentNavigationController.h"
#import "UISearchBar+AppSearchBar.h"
@import VCMaterialDesignIcons;
@import MaterialControls;
#import "UIViewController+Custom.h"
#import "MPLocationCell.h"
#import "LocalizedStrings.h"
#import "UIImageView+MPCachingImageLoader.h"
#import "Tracker.h"
#import "UIColor+AppColor.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "AppVariantData.h"
#import "MPAccessibilityHelper.h"
#import "AppFonts.h"
#import "BuildingInfoCache.h"
#import "TCFKA_MDSnackbar.h"
#import "UIViewController+Custom.h"

#define kSearchTextMinLength        2           // Only search when the length of the search text is >= than this constant.


@interface SearchViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) NSArray*          objects;
@property (nonatomic, strong) MPLocationQuery*  locationQuery;
@property (nonatomic, strong) TCFKA_MDSnackbar* snackBar;
@property (nonatomic, strong) NSTimer*          snackBarTimer;
@property (weak, nonatomic) IBOutlet UIView*    headerView;
@property (nonatomic) CGFloat                   normalTableHeaderHeight;
@property (nonatomic) BOOL                      didSelectPOI;
@property (nonatomic) BOOL                      menuIsOpen;
@property (nonatomic) BOOL                      awaitingInitialResult;

@end


@implementation SearchViewController {
    MPVenueProvider* _venueProvider;
    NSArray* _venues;
    UIActivityIndicatorView *_spinner;
    int _keyboardHeight;
}


- (void)dealloc {
    
    self.tableView.emptyDataSetSource = nil;
    self.tableView.emptyDataSetDelegate = nil;
    [self unsubscribeFromMenuOpenCloseNotification];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _venueProvider = [[MPVenueProvider alloc] init];
    
    [_venueProvider getVenuesWithCompletion:^(MPVenueCollection *venueCollection, NSError *error) {
        if (error == nil) {
            self->_venues = venueCollection.venues;
            [self.tableView reloadData];
        }
    }];
    
    _spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _spinner.hidesWhenStopped = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:_spinner selector:@selector(startAnimating) name:@"LocationsRequestStarted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocationsReady:) name:@"LocationsDataReady" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocationsDataForExternalAppSchemeReady:) name:@"LocationsDataForExternalAppSchemeReady" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reload) name:@"Reload" object:nil];
    
    [self subscribeToMenuOpenCloseNotification];

    self.headerView.backgroundColor = [UIColor appDarkPrimaryColor];
    
    self.normalTableHeaderHeight = self.headerView.frame.size.height;
    
    self.backButton.backgroundColor = [UIColor appPrimaryColor];
    self.backButton.tintColor = [UIColor whiteColor];
    [self.backButton addTarget:self action:@selector(pop) forControlEvents:UIControlEventTouchUpInside];
    self.backButton.accessibilityHint = kLangBackAccHint;   // TODO Figure out why this does *not* get read in voice over; possibly todo with being embedded in a tableview-header...
    
    self.searchBar.delegate = self;
    [self.searchBar setCustomStyle];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, 600, 184);
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f] CGColor], nil];
    gradient.startPoint = CGPointMake(0, .5f);
    gradient.endPoint = CGPointMake(0, 1.0f);
    
    CAGradientLayer *gradientTop = [CAGradientLayer layer];
    gradientTop.frame = CGRectMake(0, 0, 600, 184);
    gradientTop.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f] CGColor], nil];
    gradientTop.startPoint = CGPointMake(0.2f, 0.4f);
    gradientTop.endPoint = CGPointMake(0, 0);
    
    [self.tableView addSubview:_spinner];
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MPLocationCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"LocationCell"];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidAppear:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    if ( Global.locationQuery.query.length ) {
        self.searchBar.text = Global.locationQuery.query;
    }

    // Remove tableheader, and transfer the searchBar to the the navBar in -[viewWillAppear:animated:]
    self.tableView.tableHeaderView = nil;
    
    self.menuIsOpen = YES;      // Assume open until notified otherwise
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.didSelectPOI = NO;
    
    // Configure navBar; transfer searchbar to navBar titleView:
    [self.navigationController resetNavigationBar];
    [self presentCustomBackButton];
    
    UISearchBar*    sb = self.searchBar;
    [sb.heightAnchor constraintEqualToConstant:44].active = YES;
    [sb setBarTintColor:[UIColor clearColor]];
    sb.backgroundImage = [UIImage new];
    self.navigationItem.titleView = sb;

    if (Global.locationQuery.categories && self.category) {
        [Tracker trackScreen:self.category.value];
    } else {
        [Tracker trackScreen:@"Search"];
    }
    
    self.searchBar.placeholder = kLangSearch;
    if (Global.locationQuery && self.category.value)
        self.searchBar.placeholder = [NSString stringWithFormat:kLangSearchVar, self.category.value];
    
    _spinner.center = CGPointMake(self.view.frame.size.width*0.5, 240);
    [_spinner stopAnimating];
    
    if (_objects.count > 0) {
        [self.tableView reloadData];
    }
    
    if (Global.locationQuery.categories.count > 0 || Global.locationQuery.query.length > 0) {

        self.awaitingInitialResult = YES;
        [MapsIndoors.locationsProvider getLocationsUsingQuery:Global.locationQuery completionHandler:^(MPLocationDataset *locationData, NSError *error) {
            self.awaitingInitialResult = NO;
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    TCFKA_MDSnackbar* bar = [[TCFKA_MDSnackbar alloc] initWithText:kLangCouldNotFindLocations actionTitle:@"" duration:1.0];
                    bar.bottomPadding = self->_keyboardHeight; // show above keyboard
                    [bar show];
                });
            } else {
                if (!self.didSelectPOI) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationsDataReady" object: locationData.list];
                }
            }
        }];
    } else {
        if (!self.didSelectPOI) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationsDataReady" object: self.objects];
        }
    }
    
    //If there was an old search, perform it again
//    if (self.searchBar.text.length >= kSearchTextMinLength) {
//        [self searchBar:self.searchBar textDidChange:self.searchBar.text];
//    }
}
    
- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

    
    [self performSelector:@selector(focusSearchBar:) withObject:nil afterDelay:0.05];
}

- (void) viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    //[self unsubscribeFromMenuOpenCloseNotification];
}

- (void)viewDidLayoutSubviews {
    
    // Workaround a searchbar textfield which is wider than the tableview.
    if (@available(iOS 13.0, *)) {

    } else {

        UITextField*    tf = [self.searchBar valueForKey:@"_searchField"];
        if ( tf.bounds.size.width > self.tableView.bounds.size.width ) {
            CGRect r = tf.frame;
            r.size.width = self.tableView.bounds.size.width - r.origin.x * 2;
            [UIView animateWithDuration:0.2 animations:^{
                tf.frame = r;
            }];
        }
    }
}

- (void)focusSearchBar:(id)sender {
    if ( self.snackBar == nil || !self.snackBar.isShowing ) {
        [self.searchBar.window makeKeyAndVisible];
        [self.searchBar becomeFirstResponder];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    
    self.navigationItem.titleView = nil;

    if ( Global.locationQuery.categories.count > 0 ) {
        [self.view endEditing:YES];
        [self.searchBar resignFirstResponder];
    }
    [super viewWillDisappear:animated];
    [self dismissSnackBar];
}

- (void) pop {
    
    [Tracker trackEvent:kMPEventNameSearchDismissed parameters: @{@"Query":self.searchBar.text, @"Result_Count":@(self.objects.count)}];

    [super pop];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MPLocation*  selectedLocation = self.objects[ indexPath.row ];
    [self trackSearchWithSelectedLocation:selectedLocation.name];
    
    self.didSelectPOI = YES;
    [self performSegueWithIdentifier:@"DetailSegue" sender:nil];
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"DetailSegue"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        MPLocation *object = self.objects[indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationDetailsReady" object:object];
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

        NSMutableArray<NSString*>*  details = [NSMutableArray array];

        if ( object.roomId.length && ![object.name isEqualToString:object.roomId] ) {
            [details addObject:object.roomId];
        } 

        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"venueKey LIKE[c] %@", object.venue];
        MPVenue* venue = [[_venues filteredArrayUsingPredicate:predicate] firstObject];

        NSString*   buildingId = object.building;
        NSString*   floorId = [object.floor stringValue];
        MPBuilding* building = [[BuildingInfoCache sharedInstance] buildingFromAdministrativeId:buildingId];
        MPFloor*    floor = building.floors[floorId];
        NSString*   buildingName = building.name;
        NSString*   venueName = venue.name;

        if ( floor.name.length ) {
            [details addObject: [NSString stringWithFormat:kLangLevelVar,floor.name]];

            if ( buildingName.length && ([BuildingInfoCache sharedInstance].buildings.count > 1 || _venues.count > 1) ) {
                [details addObject: buildingName];
                if ( venueName.length && [buildingName isEqualToString:venueName] == NO ) {
                    [details addObject: venueName];
                }
            }
        } else if ( (_venues.count > 1) && venueName.length ) {
            [details addObject: venueName];
        }

        cell.subTextLabel.text = [details componentsJoinedByString:@", "];
        cell.subTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        if (object.icon) {
            cell.imageView.image = object.icon;
        } else if (object.iconUrl) {
            [cell.imageView mp_setImageWithURL:object.iconUrl.absoluteString placeholderImage:[UIImage imageNamed:@"placeholder"]];
        } else {
            [cell.imageView mp_setImageWithURL:[Global getIconUrlForType:object.type] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        }
    }

    return cell;
}


- (void)onLocationsDataForExternalAppSchemeReady:(NSNotification *)notification {
    self.objects = [NSArray arrayWithArray: notification.object ];
    [self.tableView reloadData];
    if (!self.menuIsOpen) {
        [self toggleSidebar];
    }
}

- (void)onLocationsReady:(NSNotification *)notification {

    if (Global.locationQuery.categories.count > 0 || self.searchBar.text.length >= kSearchTextMinLength) {
    
        self.objects = [NSArray arrayWithArray: notification.object ];
        [self.tableView reloadData];
        
        if (self.objects.count > 0) {
            [self dismissSnackBar];     // We have results - remove any message snackbars
        }
        
    }
    
    [_spinner stopAnimating];
}

- (void)keyboardDidAppear: (NSNotification*)notification {
    
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrame = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameRect = [keyboardFrame CGRectValue];
    _keyboardHeight = self.view.window.frame.size.height - keyboardFrameRect.origin.y;      // Software keyboard may not be visible, but an input accessory view may still be... so need to compute visible part relative to window.
    
    if ( self.objects.count == 0 ) {    // Make the "Empty" state UI center in the visible area.
        [self.tableView reloadData];
    }
}

- (void)keyboardDidHide: (NSNotification*)notification {

    _keyboardHeight = 0;

    if ( self.objects.count == 0 ) {    // Make the "Empty" state UI center in the visible area.
        [self.tableView reloadData];
    }
}


#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
   // NSString*   queryString = self.locationQuery.query ?: Global.locationQuery.query;
    
    NSUInteger  textLength = searchText.length;
    
    if ( textLength < kSearchTextMinLength ) {
        
        if ( self.locationQuery ) {
            // Only search when we have a 'local' query, meaning the user has entered text we searched for.
            self.locationQuery = nil;
            
            if ( Global.locationQuery.categories.count ) {
                // Execute original query again, as we have had a 'local' override search with user-entered text.
                [MapsIndoors.locationsProvider getLocationsUsingQuery:Global.locationQuery completionHandler:^(MPLocationDataset *locationData, NSError *error) {
                    if (error) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            TCFKA_MDSnackbar* bar = [[TCFKA_MDSnackbar alloc] initWithText:kLangCouldNotFindLocations actionTitle:@"" duration:1.0];
                            bar.bottomPadding = self->_keyboardHeight; // show above keyboard
                            [bar show];
                        });
                    } else if (!self.didSelectPOI) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationsDataReady" object: locationData.list];
                    }
                }];
                
            } else {
                self.objects = nil;
                [self.tableView reloadData];
            }
        }
        
    } else {
        
        if ( self.locationQuery == nil ) {
            
            MPLocationQuery*    originalQuery = Global.locationQuery;
            MPLocationQuery*    q = [MPLocationQuery new];
            
            self.locationQuery = q;
            
            // Clone original query:
            q.query = [originalQuery.query copy];
            q.venue = [originalQuery.venue copy];
            q.building = [originalQuery.building copy];
            q.orderBy = [originalQuery.orderBy copy];
            q.sortOrder = [originalQuery.sortOrder copy];
            q.near = [originalQuery.near copy];
            q.radius = [originalQuery.radius copy];
            q.zoomLevel = [originalQuery.zoomLevel copy];
            q.floor = [originalQuery.floor copy];
            q.mapExtend = [originalQuery.mapExtend copy];
            q.categories = [originalQuery.categories copy];
            q.types = [originalQuery.types copy];
            q.max = originalQuery.max;
            
            // ... and override a few things:
            q.near = MapsIndoors.positionProvider.latestPositionResult.geometry ?: Global.venue.anchor;
            q.orderBy = @"relevance";
            q.venue = nil;
            q.queryMode = MPLocationQueryModeAutocomplete;      // We are only interested in results from the last query performed.
        }
        
        self.locationQuery.query = self.searchBar.text;
        
        // Execute!
        [MapsIndoors.locationsProvider getLocationsUsingQuery:self.locationQuery completionHandler:^(MPLocationDataset *locationData, NSError *error) {
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    TCFKA_MDSnackbar* bar = [[TCFKA_MDSnackbar alloc] initWithText:kLangCouldNotFindLocations actionTitle:@"" duration:1.0];
                    bar.bottomPadding = self->_keyboardHeight; // show above keyboard
                    [bar show];
                });
            } else if (!self.didSelectPOI) {
                if ( textLength >= kSearchTextMinLength ) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationsDataReady" object: locationData.list];
                } else {
                    self.objects = nil;
                    [self.tableView reloadData];
                }
            }
            
            NSString* announcement = [NSString stringWithFormat:kLangNumResultsAvailableAccHint, @(locationData.list.count)];
            [[MPAccessibilityHelper sharedInstance] announceWithCompletion:announcement completion:nil];
        }];
    }
}

- (void)setDidSelectPOI:(BOOL)didSelectPOI {
    _didSelectPOI = didSelectPOI;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    _keyboardHeight = 0;
    [self trackSearchWithSelectedLocation:nil];
}

- (void) trackSearchWithSelectedLocation:(NSString*)selectedLocation {
    [Tracker trackSearch:_locationQuery results:_objects.count selectedLocation:selectedLocation];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    _keyboardHeight = 0;
    self.objects = @[];
    [self.navigationController popViewControllerAnimated:YES];
    
    [Tracker trackEvent:kMPEventNameSearchDismissed parameters: @{@"Query":searchBar.text, @"Result_Count":@(_objects.count)}];
}


#pragma mark - SnackBar Management

- (void) presentSnackBarMessage:(NSString*)msg {

    if ( (self.snackBar.isShowing == NO) || ([self.snackBar.text isEqualToString:msg] == NO) ) {
        
        self.snackBar = [[TCFKA_MDSnackbar alloc] initWithText:msg actionTitle:@"" duration:0];   // 0 duration: snackbar is visible until manually dismissed.
        self.snackBar.bottomPadding = _keyboardHeight; // show above keyboard
        [self.snackBar show];
    }
    
    [self cancelSnackBarTimer];
    [self startSnackBarTimer];
}

- (void) dismissSnackBar {
    
    [self.snackBar dismiss];
    [self cancelSnackBarTimer];
    self.snackBar = nil;
}

- (void) cancelSnackBarTimer {

    [self.snackBarTimer invalidate];
    self.snackBarTimer = nil;
}

- (void) startSnackBarTimer {
    
    self.snackBarTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(dismissSnackBar) userInfo:nil repeats:NO];
}


#pragma mark - DZNEmptyDataSetSource, DZNEmptyDataSetDelegate

- (NSAttributedString*) titleForEmptyDataSet:(UIScrollView *)scrollView
{
    if ( (self.objects.count == 0) && !self.awaitingInitialResult ) {
        
        NSString*   noMatchFormat = kLangSearchNoMatch;
        NSString*   fmt = [MPAccessibilityHelper sharedInstance].voiceOverEnabled ? kLangUseSearchToSearchFormatAccess : kLangUseSearchToSearchFormat;
        NSString*   noLocations = [NSString stringWithFormat: fmt, [AppVariantData sharedAppVariantData].appProviderName ];
        NSString*   matchToken = self.searchBar.text;
        if (matchToken.length == 0 && _category != nil) {
            matchToken = _category.value;
        }
        NSString*   text = (matchToken.length >= kSearchTextMinLength)
                         ? [NSString stringWithFormat:noMatchFormat, matchToken]
                         : noLocations;
        
        NSDictionary *attributes = @{NSFontAttributeName: [AppFonts sharedInstance].emptyStateMessageFont,
                                     NSForegroundColorAttributeName: [UIColor lightGrayColor]};
        
        return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    }
    
    return nil;
}

- (UIImage*) imageForEmptyDataSet:(UIScrollView *)scrollView {
    UIImage* image = nil;
    if (self.objects.count == 0) {
        image = [UIImage imageNamed:@"search_icon_big"];
        
        NSString*   matchToken = self.searchBar.text;
        if (matchToken.length == 0 && _category != nil) {
            matchToken = _category.value;
        }
        if (matchToken.length >= kSearchTextMinLength) {
            image = [UIImage imageNamed:@"WarningGrey"];
        }
    }
    
    return image;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    
    // DZNEmptyDataSet does not currently consider the tableview's contentInset, so we help it a bit here...
    // Ref: https://github.com/dzenbot/DZNEmptyDataSet/issues/247
    
    if ( ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) && ([UIScreen mainScreen].bounds.size.height < 568) ) {
        return -44;
    }
    if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ) {
        return - (_keyboardHeight / 2);
    }
    return 0;
}

- (void) willMoveToParentViewController:(UIViewController *)parent {
    [super willMoveToParentViewController:parent];
    
    if ( parent == nil ) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}


#pragma #pragma mark - Helpers

- (void) subscribeToMenuOpenCloseNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMenuOpenOrClose:) name:kNotificationMenuOpenClose object:nil];
}

- (void) unsubscribeFromMenuOpenCloseNotification {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotificationMenuOpenClose object:nil];
}

- (void) onMenuOpenOrClose:(NSNotification*) notification {
    
    self.menuIsOpen = [notification.userInfo[ kNotificationMenuOpenClose_IsOpenKey] boolValue];
}


@end
