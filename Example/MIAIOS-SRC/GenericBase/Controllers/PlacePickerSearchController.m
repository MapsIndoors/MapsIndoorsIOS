//
//  PlacePickerSearchController.m
//  MIAIOS
//
//  Created by Daniel Nielsen on 23/06/16.
//  Copyright © 2017-2018 MapsPeople. All rights reserved.
//

#import "PlacePickerSearchController.h"
#import "Global.h"
#import "UISearchBar+AppSearchBar.h"
#import <MapsIndoors/MapsIndoors.h>
#import "PlacePickerSearchController.h"
#import "UINavigationController+TransparentNavigationController.h"
#import "LocalizationSystem.h"
#import "MPLocationCell.h"
#import "UIColor+AppColor.h"
#import "UIImageView+MPCachingImageLoader.h"
@import MaterialControls;
@import VCMaterialDesignIcons;
#import "Tracker.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "MPGooglePlacesClient.h"
#import "MPGooglePlacesAutoCompletePrediction.h"
#import "MPGooglePlaceDetails.h"
#import "LocalizedStrings.h"
#import "NSObject+MPNetworkReachability.h"
#import <PureLayout/PureLayout.h>
#import "MPQuickAccessPointsProvider.h"
#import "UIViewController+Custom.h"
#import "NoCancelButtonSearchController.h"
#import "AppFonts.h"
#import "TCFKA_MDSnackbar.h"

typedef NS_ENUM(NSUInteger, PPSCSection) {
    PPSCSection_MyLocation,
    PPSCSection_QuickAccessPoints,
    PPSCSection_MapsIndoorsResults,
    PPSCSection_GoogleResults,
    
    PPSCSection_Count
};

#define kSearchTextMinLength        2           // Only search when the length of the search text is >= than this constant.


@interface PlacePickerSearchController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

    @property NSArray*                                      locations;
    @property NSMutableArray*                               places;
    @property (nonatomic, strong) TCFKA_MDSnackbar*         snackBar;
    @property (nonatomic, strong) NSTimer*                  snackBarTimer;
    @property (nonatomic) BOOL                              searchingIndoorLocations;
    @property (nonatomic) BOOL                              searchingPlacesLocations;
    @property (nonatomic, strong) MPGooglePlacesClient*     placesClient;
    @property (nonatomic, strong) UIImageView*              poweredByGoogleView;
    @property (nonatomic, strong) UIView*                   noGoogleResultsTableFooterView;
    @property (nonatomic, strong) UIView*                   emptyTableFooterView;
    @property (nonatomic, strong) UIView*                   offlineTableFooterView;
    @property (nonatomic, strong) UIView*                   footerViewForMyLocationNoSearchNoQuickAccesPoints;
    @property (nonatomic, weak) UIView*                     activeTableFooterView;
    @property (nonatomic, weak) UIActivityIndicatorView*    reachabilitySpinner;
    @property (nonatomic, strong) NSArray<MPLocation*>*     quickAccessPoints;

@end

@implementation PlacePickerSearchController {

    MPLocationQuery* _locationQuery;
    UIActivityIndicatorView *_spinner;
    UIView* _tableHeaderView;
    mpLocationSelectBlockType _selectCallback;
    MPVenueProvider* _venueProvider;
    NSArray* _venues;
    NSArray* _buildings;
    int _keyboardHeight;
    BOOL _cancelling;
    UIImage* _placesIcon;
}

static NSString* cellIdentifier = @"LocationCell";

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.tableView.rowHeight = UITableViewAutomaticDimension;

    self.placesClient = [MPGooglePlacesClient new];
    _locationQuery = [[MPLocationQuery alloc] init];
    _venueProvider = [[MPVenueProvider alloc] init];
    self.places = [NSMutableArray array];
    
    VCMaterialDesignIcons* icon = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_pin fontSize:32];
    [icon addAttribute:NSForegroundColorAttributeName value:[UIColor appSecondaryTextColor]];
    _placesIcon = icon.image;
    
    [_venueProvider getVenuesWithCompletion:^(MPVenueCollection *venueCollection, NSError *error) {
        if (error == nil) {
            _venues = venueCollection.venues;
            [self.tableView reloadData];
        }
    }];
    
    [_venueProvider getBuildingsWithCompletion:^(NSArray *buildings, NSError *error) {
        if (error == nil) {
            _buildings = buildings;
            [self.tableView reloadData];
        }
    }];
    
    NSString* qapVenueId = Global.venue.venueKey;
    [[MPQuickAccessPointsProvider sharedInstance] getQuickAccessPointsForVenue:qapVenueId completion:^(MPLocationDataset * _Nullable locationData, NSError * _Nullable error) {
        
        if ( locationData.list.count ) {
            self.quickAccessPoints = [locationData.list copy];
            
            [self.tableView reloadData];
        }
    }];

    self.searchController = [[NoCancelButtonSearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    [self.searchController.searchBar setCustomStyle];
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    self.navigationItem.titleView = self.searchController.searchBar;
    
    [[UITextField appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    _spinner.hidesWhenStopped = YES;
    [self.tableView addSubview:_spinner];
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MPLocationCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
    
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.emptyTableFooterView = [UIView new];  // A little trick for removing the cell separators
    [self updateTableFooter];
    
    UIImage*    poweredByImage = [UIImage imageNamed:@"powered_by_google_on_white"];
    self.poweredByGoogleView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.view.bounds.size.width, 14)];
    self.poweredByGoogleView.contentMode = UIViewContentModeScaleAspectFit;
    self.poweredByGoogleView.image = poweredByImage;
    
    [self presentCustomBackButton];
    
    __weak typeof(self)weakSelf = self;
    [self mp_onReachabilityChange:^(BOOL isNetworkReachable) {
        [weakSelf updateTableFooter];
        
        if ( isNetworkReachable && (weakSelf.places.count == 0) && (weakSelf.searchController.searchBar.text.length >= kSearchTextMinLength) ) {
            [weakSelf retrySearch];
        }
    }];
}

- (void)dealloc {
    
    self.tableView.emptyDataSetSource = nil;
    self.tableView.emptyDataSetDelegate = nil;
}

- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController resetNavigationBar];
    
    [Tracker trackScreen:@"Select Place"];
    
    self.searchController.searchBar.placeholder = kLangSearch;
    if (_locationQuery && _locationQuery.types) {
        self.searchController.searchBar.placeholder = [NSString stringWithFormat:kLangSearchVar, [_locationQuery.types firstObject]];
    }
    
    if (self.selectedLocation) {
        self.searchController.searchBar.text = self.selectedLocation.name;
    }
    
    _spinner.center = CGPointMake(self.view.frame.size.width*0.5, 240);
    [_spinner stopAnimating];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidAppear:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}


- (void) viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    
    self.selectedLocation = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    [self performSelector:@selector(focusSearchBar:) withObject:nil afterDelay:0.05];
}

- (void) focusSearchBar:(id)sender {
    
    [self.searchController.searchBar.window makeKeyAndVisible];
    [self.searchController.searchBar becomeFirstResponder];
    self.searchController.active = YES;
}

- (void) keyboardDidAppear:(NSNotification*)notification {
    
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrame = [keyboardInfo valueForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardFrameRect = [keyboardFrame CGRectValue];
    _keyboardHeight = self.view.window.frame.size.height - keyboardFrameRect.origin.y;      // Software keyboard may not be visible, but an input accessory view may still be... so need to compute visible part relative to window.
    
    NSUInteger  numSearchResults = self.locations.count + self.places.count;
    BOOL        isSearching = (self.searchController.searchBar.text.length >= kSearchTextMinLength);
    if ( (numSearchResults == 0) && isSearching ) {
        [self.tableView reloadData];
    }
}

- (void) keyboardDidHide:(NSNotification*)notification {

    _keyboardHeight = 0;
    
    NSUInteger  numSearchResults = self.locations.count + self.places.count;
    BOOL        isSearching = (self.searchController.searchBar.text.length >= kSearchTextMinLength);
    if ( (numSearchResults == 0) && isSearching ) {
        [self.tableView reloadData];
    }
}


#pragma mark - tableFooterView management

- (void) setActiveTableFooterView:(UIView*) activeTableFooterView {
    
    if ( _activeTableFooterView != activeTableFooterView ) {
        _activeTableFooterView = activeTableFooterView;
        self.tableView.tableFooterView = activeTableFooterView;
    }
}

- (UIView*) offlineTableFooterView {
    
    if ( _offlineTableFooterView == nil ) {
        _offlineTableFooterView = [UIView new];
        _offlineTableFooterView.userInteractionEnabled = YES;
        [_offlineTableFooterView configureForAutoLayout];
        [_offlineTableFooterView autoSetDimensionsToSize:CGSizeMake(self.tableView.bounds.size.width, 44)];
        
        // Offline image:
        UIImageView*    imageView = [[UIImageView alloc] initForAutoLayout];
        [imageView autoSetDimensionsToSize:CGSizeMake(26,26)];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tintColor = [UIColor lightGrayColor];
        [_offlineTableFooterView addSubview: imageView];
        [imageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:16];
        [imageView autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:8];

        UIImage*    img = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_cloud_off fontSize:36.f].image;
        imageView.image = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        // Label
        UILabel*    label = [[UILabel alloc] initForAutoLayout];
        label.text = kLangOfflineTryToReconnect;
        label.textColor = [UIColor appTertiaryHighlightColor];
        label.font = [AppFonts sharedInstance].infoMessageFont;
        [label autoSetDimension:ALDimensionHeight toSize: [[AppFonts sharedInstance] scaledFontSizeForFontSize: 16]];
        [_offlineTableFooterView addSubview:label];
        [label autoAlignAxis:ALAxisHorizontal toSameAxisOfView:imageView];
        [label autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imageView withOffset:16];
        
        // Spinner
        UIActivityIndicatorView*    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.hidesWhenStopped = YES;
        [spinner configureForAutoLayout];
        [_offlineTableFooterView addSubview:spinner];
        [spinner autoAlignAxis:ALAxisHorizontal toSameAxisOfView:imageView];
        [spinner autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:8 relation:NSLayoutRelationGreaterThanOrEqual];
        [label autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:spinner withOffset:-16];
        self.reachabilitySpinner = spinner;
        
        // Bottom separator
        UIView*     separator = [[UIView alloc] initForAutoLayout];
        [separator autoSetDimension:ALDimensionHeight toSize:1];
        separator.backgroundColor = [UIColor lightGrayColor];
        [_offlineTableFooterView addSubview: separator];
        [separator autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0,0,0,0) excludingEdge:ALEdgeTop];
        
        UITapGestureRecognizer* tapToRetrySearch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(retrySearch)];
        [_offlineTableFooterView addGestureRecognizer:tapToRetrySearch];
    }
    
    return _offlineTableFooterView;
}

- (UIView*) tableFooterViewWithText:(NSString*)s {

    UILabel*    label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,self.tableView.bounds.size.width, 44)];
    label.text = s;
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [AppFonts sharedInstance].infoMessageFont;
    
    return label;
}

- (UIView*) noGoogleResultsTableFooterView {
    
    if ( _noGoogleResultsTableFooterView == nil ) {
        
        _noGoogleResultsTableFooterView = [self tableFooterViewWithText:kLangNoInternetNoGoogleResults];
    }
    
    return _noGoogleResultsTableFooterView;
}

- (UIView*) footerViewForMyLocationNoSearchNoQuickAccesPoints {
    
    if ( _footerViewForMyLocationNoSearchNoQuickAccesPoints == nil ) {
        
        _footerViewForMyLocationNoSearchNoQuickAccesPoints = [self tableFooterViewWithText:kLangSearchLocationsIndoorsAndOutdoors];
    }
    
    return _footerViewForMyLocationNoSearchNoQuickAccesPoints;
}

- (void) retrySearch {
    
    _locationQuery.query = @"";
    [self.reachabilitySpinner startAnimating];
    [self updateSearchResultsForSearchController:self.searchController];
}

- (void) updateTableFooter {
    
    UIView*     footerView = self.activeTableFooterView;
    BOOL        isNetworkReachable = [self mp_isNetworkReachable];
    BOOL        isSearching = (self.searchController.searchBar.text.length >= kSearchTextMinLength);
    
    if ( !self.searchingIndoorLocations && !self.searchingPlacesLocations ) {
        
        if ( self.places.count ) {
            footerView = self.poweredByGoogleView;
            
        } else if ( self.locations.count ) {
            
            footerView = isNetworkReachable || !isSearching ? self.emptyTableFooterView : self.noGoogleResultsTableFooterView;
        
        } else if ( isSearching && (isNetworkReachable == NO) ) {
            footerView = self.offlineTableFooterView;

        } else if ( self.myLocation && (self.quickAccessPoints.count == 0) ) {
            footerView = self.footerViewForMyLocationNoSearchNoQuickAccesPoints;
            
        } else {
            footerView = self.emptyTableFooterView;
        }
    }
    
    self.activeTableFooterView = footerView;
}


#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    
    return PPSCSection_Count;
}
    
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger   numRows = 0;
    
    if ( !self.searchingIndoorLocations && !self.searchingPlacesLocations ) {

        NSUInteger  numSearchResults = self.locations.count + self.places.count;
        BOOL        isSearching = (self.searchController.searchBar.text.length >= kSearchTextMinLength);

        switch ( (PPSCSection)section ) {
            case PPSCSection_MyLocation:
                numRows = self.myLocation && (numSearchResults == 0) && (isSearching == NO) ? 1 : 0;
                break;
                
            case PPSCSection_QuickAccessPoints:
                numRows = (numSearchResults == 0) && (isSearching == NO) ? self.quickAccessPoints.count : 0;
                break;
                
            case PPSCSection_MapsIndoorsResults:
                numRows = self.locations.count;
                break;
                
            case PPSCSection_GoogleResults:
                numRows = self.places.count;
                break;
                
            case PPSCSection_Count:
                break;
        }
    }

    [self updateTableFooter];
    
    return numRows;
}

- (MPLocation*) objectForIndexPath:(NSIndexPath * _Nonnull)indexPath {
    
    MPLocation *object;
    switch ( (PPSCSection)indexPath.section ) {
        
        case PPSCSection_MyLocation:
            return self.myLocation;
            break;
            
        case PPSCSection_QuickAccessPoints:
            object = indexPath.row < self.quickAccessPoints.count ? self.quickAccessPoints[indexPath.row] : nil;
            break;
            
        case PPSCSection_MapsIndoorsResults:
            object = indexPath.row < self.locations.count ? self.locations[indexPath.row] : nil;
            break;
            
        case PPSCSection_GoogleResults:
            object = indexPath.row < self.places.count ? self.places[indexPath.row] : nil;
            break;
            
        case PPSCSection_Count:
            break;
    }
    
    return object;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MPLocationCell *cell = (MPLocationCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"LocationCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    MPLocation * object = [self objectForIndexPath:indexPath];
    
    cell.textLabel.text = [object name];
    
    NSMutableArray<NSString*>*  details = [NSMutableArray array];

    if ( object.roomId.length && ![object.name isEqualToString:object.roomId] ) {
        [details addObject:object.roomId];
    }

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"venueKey LIKE[c] %@", object.venue];
    MPVenue* venue = [[_venues filteredArrayUsingPredicate:predicate] firstObject];

    NSString*   buildingId = object.building;
    NSString*   floorId = [object.floor stringValue];
    NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"administrativeId LIKE[c] %@", buildingId];
    MPBuilding* building = [[_buildings filteredArrayUsingPredicate:bPredicate] firstObject];
    MPFloor*    floor = building.floors[floorId];
    NSString*   buildingName = building.name;
    NSString*   venueName = venue.name;

    if ( floor.name.length ) {
        [details addObject: [NSString stringWithFormat:kLangLevelVar,floor.name]];

        if ( (_buildings.count > 1) || (_venues.count > 1) ) {
            [details addObject: buildingName];
            if ( [buildingName isEqualToString:venueName] == NO ) {
                [details addObject: venueName];
            }
        }
    } else if ( venueName.length && (_venues.count > 1) ) {    // Google results have no venuename
        [details addObject: venueName];
    }

    cell.subTextLabel.text = [details componentsJoinedByString:@", "];
    cell.subTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;

    if (object.icon) {
        
        cell.imageView.image = object.icon;
        
    } else if (object.iconUrl) {
        
        [cell.imageView mp_setImageWithURL: object.iconUrl.absoluteString placeholderImageName:@"placeholder"];
        
    } else if ([object.type isEqualToString:@"google-place"]) {
        
        cell.imageView.image = _placesIcon;

        NSString*   subText = object.fields[@"placesSecondaryText"].value;
        if ( subText.length ) {
            cell.subTextLabel.text = subText;
        } else {
            [cell centerTextLabelVertically];
        }
        
    } else if ([@[@"my position", @"min placering"] containsObject: [object.name lowercaseString]]) {
        
        if ( object.descr.length ) {
            cell.textLabel.text = kLangMyPosition;
            cell.subTextLabel.text = object.descr;
        }
            
        [cell.imageView setImage:[UIImage imageNamed:@"MyLocation"]];

    } else {
        [cell.imageView mp_setImageWithURL:[Global getIconUrlForType:object.type] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    }
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.selectedLocation = [self objectForIndexPath:indexPath];

    NSUInteger  numResults = self.places.count + self.locations.count;
    [Tracker trackDirectionsSearch:self.searchController.searchBar.text results:numResults selectedLocation:self.selectedLocation.name isOriginSearch:self.isOriginSearch];
    
    [self.view endEditing:YES];
    if ( self.navigationController.presentedViewController ) {      // We have a UISearchController presented above the PlacePickerSearchController.
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    }
    
    if ([self.selectedLocation.type isEqualToString:@"google-place"]) {

        NSString*   placesId = self.selectedLocation.fields[@"placeID"].value;

        [self.placesClient placeDetailsFromPlaceId:placesId callback:^(MPGooglePlacesClient *placesClient, MPGooglePlacesResult result, NSDictionary *placeDict, NSError *error) {
            
            if ( error == nil ) {
                MPGooglePlaceDetails*   placeDetails = [MPGooglePlaceDetails newWithDict:placeDict];

                MPLocationUpdate*   locationBuilder = [MPLocationUpdate updateWithLocation:self.selectedLocation];
                locationBuilder.name = self.selectedLocation.name;
                locationBuilder.position = placeDetails.location;
                self.selectedLocation = locationBuilder.location;

                if (self.placePickerDelegate) {
                    [self.placePickerDelegate onLocationSelected:self.selectedLocation];
                }
                if (_selectCallback) {
                    _selectCallback(self.selectedLocation);
                }
            }
            
            [self trackAnalyticsForPlacesResult:result];
        }];
        
    } else {
        if (self.placePickerDelegate) {
            [self.placePickerDelegate onLocationSelected:self.selectedLocation];
        }
        if (_selectCallback) {
            _selectCallback(self.selectedLocation);
        }
    }
}

- (void) updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    if (_cancelling) return;
    
    if ( searchController.searchBar.text.length < kSearchTextMinLength ) {
        
        self.searchingIndoorLocations = self.searchingPlacesLocations = NO;
        self.locations = @[];
        self.places = [NSMutableArray array];
        [self.tableView reloadData];
        
    } else if (![_locationQuery.query isEqual:searchController.searchBar.text] && searchController.searchBar.text.length >= kSearchTextMinLength) {
        
        self.searchingIndoorLocations = self.searchingPlacesLocations = YES;
        
        _locationQuery.near = Global.venue.anchor;
        _locationQuery.query = searchController.searchBar.text;
        _locationQuery.max = 25;
        _locationQuery.orderBy = @"relevance";
        _locationQuery.queryMode = MPLocationQueryModeAutocomplete;      // We are only interested in results from the last query performed.
        
        self.locations = @[];
        [self.places removeAllObjects];
        
        [MapsIndoors.locationsProvider getLocationsUsingQuery:_locationQuery completionHandler:^(MPLocationDataset *locationData, NSError *error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.searchingIndoorLocations = NO;
                
                if (error) {
                    [self presentSnackBarMessage: @"Failed to get locations"];
                    
                } else {
                    
                    self.locations = locationData.list;
                    
                    if (self.locations.count > 0) {
                        [self dismissSnackBar];
                    }
                }
                
                [self.tableView reloadData];
                [_spinner stopAnimating];
                [self.reachabilitySpinner stopAnimating];
            });
        }];
        
        if ( self.myLocation ) {
            [self.placesClient setLocationBiasWithRadius:40000 latitude:self.myLocation.geometry.lat longitude:self.myLocation.geometry.lng strictBounds:NO];
        } else {
            // When we have no location, bias towards the apps hardcoded, initial position in London:
            [self.placesClient setLocationBiasWithRadius:40000 latitude:Global.initialPosition.lat longitude:Global.initialPosition.lng strictBounds:NO];
        }
        
        [self.placesClient autoComplete:_locationQuery.query callback:^(MPGooglePlacesClient *placesClient, MPGooglePlacesResult result, NSArray<NSDictionary *> *placesPredictions, NSError *error) {
            
            self.searchingPlacesLocations = NO;
            self.places = [NSMutableArray array];
            
            if (error == nil) {
                
                for (NSDictionary* placeDict in placesPredictions) {
                    MPGooglePlacesAutoCompletePrediction*   placeDetails = [MPGooglePlacesAutoCompletePrediction newWithDict:placeDict];
                    MPLocationUpdate*       locationBuilder = [MPLocationUpdate new];
                    locationBuilder.name = [placeDetails.attributedPrimaryText string];
                    locationBuilder.floor = 0;
                    locationBuilder.type = @"google-place";
                    [locationBuilder addPropertyValue:placeDetails.placeID forKey:@"placeID"];
                    [locationBuilder addPropertyValue:[placeDetails.attributedSecondaryText string] forKey:@"placesSecondaryText"];

                    MPLocation* googleLoc = locationBuilder.location;
                    [_places addObject:googleLoc];
                }
            }
            
            [self.tableView reloadData];

            [self trackAnalyticsForPlacesResult:result];
        }];
    }
}

- (void) trackAnalyticsForPlacesResult:(MPGooglePlacesResult)result {
    
    switch ( result ) {
        case MPGooglePlacesResult_OVER_QUERY_LIMIT:
            [Tracker trackEvent:kMPEventNamePlacesAPI parameters:@{@"Error": @"OVER_QUERY_LIMIT"}];
            break;
        case MPGooglePlacesResult_REQUEST_DENIED:
            [Tracker trackEvent:kMPEventNamePlacesAPI parameters:@{@"Error": @"REQUEST_DENIED"}];
            break;
            
        default:
            break;
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {

    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    _keyboardHeight = 0;
    if (_locations.count > 0) {
        if (self.placePickerDelegate) {
            [self.placePickerDelegate onLocationSelected:[_locations firstObject]];
        }
        if (_selectCallback) {
            _selectCallback([_locations firstObject]);
        }
    } else if (_places.count > 0) {
        if (self.placePickerDelegate) {
            [self.placePickerDelegate onLocationSelected:[_places firstObject]];
        }
        if (_selectCallback) {
            _selectCallback([_places firstObject]);
        }
    }
}

- (void) searchBarCancelButtonClicked:(UISearchBar *)searchBar {
 
    [self dismissPlacePicker];
}

- (void) placePickerSelectCallback: (mpLocationSelectBlockType)selectCallbackFn {
    _selectCallback = selectCallbackFn;
}

- (void) dismissPlacePicker {
    
    [self dismissSnackBar];
    
    _cancelling = YES;
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (self.placePickerDelegate) {
            [self.placePickerDelegate onLocationSelected:nil];
        }
        if (_selectCallback) {
            _selectCallback(nil);
        }
        [_places removeAllObjects];
        _locations = @[];
    }];
}

- (void) pop {
    
    [self dismissPlacePicker];
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
    if ( (self.locations || self.places) && ((self.locations.count + self.places.count) == 0) ) {
        
        NSDictionary*   attributes = @{ NSFontAttributeName            : [AppFonts sharedInstance].emptyStateMessageFont,
                                        NSForegroundColorAttributeName : [UIColor lightGrayColor]
                                        };
        NSString*   noMatchFormat = kLangSearchNoMatch;
        NSString*   noLocations = kLangSearchLocationsIndoorsAndOutdoors;
        NSString*   text = (self.searchController.searchBar.text.length >= kSearchTextMinLength)
                         ? [NSString stringWithFormat:noMatchFormat, self.searchController.searchBar.text]
                         : noLocations;
        
        return [[NSAttributedString alloc] initWithString:text attributes:attributes];
    }
    
    return nil;
}

- (UIImage*) imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSUInteger  numSearchResults = self.locations.count + self.places.count;
    
    if ( (self.locations || self.places) && (numSearchResults == 0) ) {
        
        return (self.searchController.searchBar.text.length >= kSearchTextMinLength) ? [UIImage imageNamed:@"WarningGrey"] : [UIImage imageNamed:@"search_icon_big"];
    }
    
    return nil;
}

- (UIView *)customViewForEmptyDataSet:(UIScrollView *)scrollView {
 
    if ( self.searchingIndoorLocations || self.searchingPlacesLocations ) {
        
        UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.hidesWhenStopped = YES;
        [spinner startAnimating];
        return spinner;
    }
    
    return nil;
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

@end
