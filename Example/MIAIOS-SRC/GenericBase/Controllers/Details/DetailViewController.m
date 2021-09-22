//
//  DetailViewController.m
//  MIAIOS
//
//  Created by Daniel Nielsen on 10/08/15.
//  Copyright (c) 2015-2018 MapsPeople A/S. All rights reserved.
//


#import "Global.h"
#import "DetailViewController.h"
#import "UINavigationController+TransparentNavigationController.h"
#import "DirectionsController.h"
#import <MapsIndoors/MapsIndoors.h>
#import "UIColor+AppColor.h"
#import "UIButton+AppButton.h"
#import "UIViewController+Custom.h"
#import "AppDelegate.h"
#import "LocalizedStrings.h"
#import "UIImageView+MPCachingImageLoader.h"
#import "Tracker.h"
#import "DetailsTableViewCell.h"
#import "NSObject+MPNetworkReachability.h"
#import "MPReverseGeocodingService.h"
#import "NSString+TRAVEL_MODE.h"
#import "SectionModel.h"
#import "MPRoute+SectionModel.h"
#import "MPDirectionsViewModel.h"
#import "NSObject+ContentSizeChange.h"
#import "AppFonts.h"
#import "TCFKA_MDSnackbar.h"
#import "BookingDetailsViewModel.h"
#import "BookingDetailsEntry.h"
#import <NSObject+FBKVOController.h>
#import "NSObject+MPUserInfo.h"


@import VCMaterialDesignIcons;
@import PureLayout;


typedef NS_ENUM(NSUInteger, DetailSection) {
    DetailSection_OfflineMessage,
    DetailSection_LocationDetails,
    DetailSection_Booking,

    DetailSection_Count
};


@interface DetailViewController ()

@property (nonatomic) NSMutableSet*                                 operationsInProgress;
@property (nonatomic, strong) MPRoute*                              route;
@property (nonatomic, strong) NSDictionary<NSString*,NSString*>*    categoriesMap;
@property (nonatomic, strong) NSString*                             subTitleForDirectionsCell;
@property (nonatomic, strong) BookingDetailsViewModel*              bookingDetailsViewModel;

@end


@implementation DetailViewController {
    
    NSMutableArray* _fields;
    RoutingData* _routing;
    UIButton* _routeBtn;
    UIButton* _showMapBtn;
    MPLocation* _from;
    MPVenueProvider* _venueProvider;
    NSArray* _buildings;
    NSArray* _venues;
    AFNetworkReachabilityManager *manager;
    
    BOOL isLocationTurnedOff;
    BOOL isConnected;
}

@synthesize location = _location;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if ( self.operationsInProgress == nil ) {
        
        self.operationsInProgress = [NSMutableSet set];
        
        _routing = Global.routingData;
        _routing.travelMode = Global.travelMode;
        
        isLocationTurnedOff = false;
        
        if ( [self beginOperation:@"getBuildingsAsync"] ) {
            _venueProvider = [[MPVenueProvider alloc] init];
            [_venueProvider getBuildingsWithCompletion:^(NSArray *buildings, NSError *error) {
                if (error == nil) {
                    self->_buildings = buildings;
                }
                [self endOperation:@"getBuildingsAsync"];
            }];
        }
        
        if ( [self beginOperation:@"getVenuesAsync"] ) {
            [_venueProvider getVenuesWithCompletion:^(MPVenueCollection *venueCollection, NSError *error) {
                if (error == nil) {
                    self->_venues = venueCollection.venues;
                }
                [self endOperation:@"getVenuesAsync"];
            }];
        }
        
        if ( [self beginOperation:@"getCategoriesWithCompletion"] ) {
            MPCategoriesProvider*   categoriesProvider = [MPCategoriesProvider new];
            [categoriesProvider getCategoriesWithCompletion:^(NSArray<MPDataField *> *categories, NSError *error) {
                
                NSMutableDictionary*    categoriesMap = [NSMutableDictionary dictionary];
                for ( MPDataField* df in categories ) {
                    NSString*   key = df.key.length ? df.key : df.value;
                    if ( key.length && df.value.length ) {
                        categoriesMap[ key ] = df.value;
                    }
                }
                self.categoriesMap = [categoriesMap copy];
                
                [self endOperation:@"getCategoriesWithCompletion"];

                [self reloadLocationData];
            }];
        }
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocationsRequestStarted:) name:@"LocationsRequestStarted" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocationDetailsReady:) name:@"LocationDetailsReady" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRouteResultReady:) name:@"RoutingDataReady" object:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [Tracker trackScreen:@"Details"];
    
    isConnected = [AFNetworkReachabilityManager sharedManager].reachable;
    
    [self presentCustomBackButton];
    
    [self setupShareButtonForCurrentLocation];
    
    [self.navigationController presentTransparentNavigationBar];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    // Stop updating route data when we disappear the first time (Else going to "Get Directions" will trigger a (partial) update of the displayed data, resulting in inconsistent data being displayed).
    if ( self.route ) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RoutingDataReady" object:nil];
    }
}

- (void) setupShareButtonForCurrentLocation {
    
    if ( [Global.solution getMapClientUrlForVenueId:Global.venue.venueId locationId:_location.locationId].length > 0 ) {
        
        UIImage* shareImg = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_share fontSize:28.0f].image;
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:shareImg style:UIBarButtonItemStylePlain target:self action:@selector(shareLocation)];

    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void) pop: (id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) onLocationsRequestStarted:(NSNotification*)notification {
    
    [self showSpinnerIfNeeded];
}

- (void) onLocationDetailsReady:(NSNotification*)notification {
    
    if (_location != notification.object) {
        _fields = [NSMutableArray arrayWithCapacity:0];
        
        self.location = notification.object;
        [self setupShareButtonForCurrentLocation];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLocationOnMap" object:_location];
    }
}

- (BOOL) shouldShowSpinner {
    
    return self.operationsInProgress.count > 0;
}

- (void) showSpinnerIfNeeded {
    
    if ( [NSThread isMainThread] ) {
        [self _showSpinnerIfNeeded];
        
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self _showSpinnerIfNeeded];
        });
    }
}

- (void) _showSpinnerIfNeeded {

    if ( self.tableView ) {
        
        if ( [self shouldShowSpinner] ) {
            
            if ( (self.tableView.tableFooterView == nil) && [self mp_isNetworkReachable] ) {
                UIActivityIndicatorView* spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
                spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
                [spinner startAnimating];
                self.tableView.tableFooterView = spinner;
            }
            
        } else {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if ( self.operationsInProgress.count == 0 ) {
                    self.tableView.tableFooterView = nil;
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:DetailSection_OfflineMessage] withRowAnimation:UITableViewRowAnimationAutomatic];
                }
            });
        }
    }
}

- (void)shareLocation { 
    
    NSString*   sUrl = [Global.solution getMapClientUrlForVenueId:Global.venue.venueId locationId:self.location.locationId];
    NSURL* url = [NSURL URLWithString:sUrl];
    UIActivityViewController* shareCtrl = [[UIActivityViewController alloc] initWithActivityItems:@[url] applicationActivities:nil];
    AppDelegate* app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        shareCtrl.popoverPresentationController.barButtonItem = self.navigationItem.rightBarButtonItem;
    }
    
    [app.window.rootViewController presentViewController:shareCtrl animated:YES completion:nil];
    
    [Tracker trackEvent:@"Location_Share" parameters:nil];
}

- (void) reloadLocationData {

    _fields = [NSMutableArray array];
    self.location = _location;
}

- (void)setLocation:(MPLocation *)location {
        
    _location = location;

    self.bookingDetailsViewModel = [BookingDetailsViewModel newWithBookableLocation:location];

    if (_location) {
        
        if (_location.categories.allKeys.count > 0 || _location.externalId) {
            NSMutableArray<NSString*>*      categoryNames = [NSMutableArray array];
            for ( NSString* key in _location.categories.allKeys ) {

                NSString*   categoryName = _location.categories[key];
                if ( categoryName.length == 0 ) {
                    categoryName = self.categoriesMap[key];
                }
                [categoryNames addObject: categoryName.length ? categoryName : key];        // Show category name with fallback to key.
            }
            [categoryNames sortUsingSelector:@selector(localizedStandardCompare:)];
            NSString* infoText = [categoryNames componentsJoinedByString:@", "] ?: @"";
            if (_location.externalId) {
                infoText = infoText.length ? [infoText stringByAppendingFormat:@"\n%@", _location.externalId] : _location.externalId;
            }
            [_fields addObject:@{@"text": infoText, @"icon": [self materialIcon:VCMaterialDesignIconCode.md_info]}];
        }
        
        if (_location.descr != nil && _location.descr.length > 0) {
            
            [_fields addObject:@{@"text": _location.descr, @"icon": [self materialIcon:VCMaterialDesignIconCode.md_file_text]}];
        }
        
        MPLocationUpdate* originLocationUpdate = [MPLocationUpdate updateWithLocation:[MPLocation new]];
        originLocationUpdate.position = [MapsIndoors.positionProvider.latestPositionResult.geometry getCoordinate];
        originLocationUpdate.floor = [MapsIndoors.positionProvider.latestPositionResult getFloor].integerValue;
        originLocationUpdate.name = kLangMyPosition;
        _from = originLocationUpdate.location;
        
        MPLocationQuery* query = [[MPLocationQuery alloc] init];
        query.near = _from.geometry;
        query.floor = _from.floor;
        query.max = 1;
        query.radius = [NSNumber numberWithInt:15];
        
        if ( [self beginOperation:@"getLocationsUsingQueryAsync"] ) {
            
            [MapsIndoors.locationsProvider getLocationsUsingQuery:query completionHandler:^(MPLocationDataset *locationData, NSError *error) {
                [self endOperation:@"getLocationsUsingQueryAsync"];
                
                if (locationData != nil && locationData.list.count == 1) {
                    self->_from = [locationData.list.firstObject copy];
                    self.subTitleForDirectionsCell = [NSString stringWithFormat: kLangFromPosVar, self->_from.name];
                }
                else if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        TCFKA_MDSnackbar* bar = [[TCFKA_MDSnackbar alloc] initWithText:kLangCouldNotFindLocationDetails actionTitle:@"" duration:1.0];
                        [bar show];
                    });
                } else {
                    self.subTitleForDirectionsCell = nil;
                    [[MPReverseGeocodingService sharedGeoCoder] reverseGeocodeCoordinate:CLLocationCoordinate2DMake(query.near.lat, query.near.lng) completionHandler:^(GMSReverseGeocodeResponse * _Nullable result, NSError * _Nullable error) {
                        if (error == nil && result != nil) {
                            NSString*   s = [result.firstResult.lines componentsJoinedByString:@", "];
                            self.subTitleForDirectionsCell = [NSString stringWithFormat: kLangFromPosVar, s];
                            [self.tableView reloadData];
                        }
                    }];
                }
            }];
        }
        
        if ( _from && _location && _from.geometry && _location.geometry && _from.geometry.lat != 0 ) {
            [self beginOperation:@"routingFrom"];
            
            NSArray*    avoids = Global.avoidStairs ? @[@"stairs"] : nil;
            [_routing routingFrom: _from to: _location by:_routing.travelMode avoid:avoids depart:nil arrive:nil];
        
        } else {
            _routing.origin = _from;
            _routing.destination = _location;
            _routing.latestRoutingRequestHash = 0;
            _routing.latestRoute = nil;
            _routing.latestModelArray = nil;
        }
        
        self.titleLabel.text = _location.name;
        self.titleLabel.font = [AppFonts sharedInstance].headerTitleFont;

        NSString* headerImageUrl = [Global.appData.venueImages objectForKey:Global.venue.venueKey];
        
        if (_location.fields) {
            for (NSString* key in _location.fields.keyEnumerator) {
                MPLocationField* field = [_location.fields objectForKey:key];
                if (field.value && field.value.length > 1) {
                    if (!([[key lowercaseString] isEqualToString:@"imageurl"] || [key isEqualToString:@"image"])) {
                        //Not image
                        if ([key isEqualToString:@"openinghours"]) [_fields addObject:@{@"type": key, @"text": field.value, @"icon": [self materialIcon:VCMaterialDesignIconCode.md_time]}];
                        if ([key isEqualToString:@"website"]) [_fields addObject:@{@"type": key, @"text": field.value, @"icon": [self materialIcon:VCMaterialDesignIconCode.md_link]}];
                        if ([key isEqualToString:@"phone"]) [_fields addObject:@{@"type": key, @"text": field.value, @"icon": [self materialIcon:VCMaterialDesignIconCode.md_phone]}];
                        if ([key isEqualToString:@"email"]) [_fields addObject:@{@"type": key, @"text": field.value, @"icon": [self materialIcon:VCMaterialDesignIconCode.md_email]}];
                    } else {
                        //Image
                        headerImageUrl = field.value;
                    }
                }
            }
        }
        
        NSPredicate *bPredicate = [NSPredicate predicateWithFormat:@"administrativeId LIKE[c] %@", _location.building];
        MPBuilding* building = [[_buildings filteredArrayUsingPredicate:bPredicate] firstObject];
        
        NSPredicate *vPredicate = [NSPredicate predicateWithFormat:@"venueKey LIKE[c] %@", _location.venue];
        MPVenue* venue = [[_venues filteredArrayUsingPredicate:vPredicate] firstObject];
        if (building) {
            
            if ( [self beginOperation:@"getBuildingDetailsAsync"] ) {
                [_venueProvider getBuildingWithId:building.buildingId completionHandler:^(MPBuilding *building, NSError *error) {
                    [self endOperation:@"getBuildingDetailsAsync"];
                    
                    if(error == nil) {
                        MPFloor* floor = [building.floors objectForKey:[self->_location.floor stringValue]];
                        [self->_fields addObject:@{@"type": @"place", @"text": [NSString stringWithFormat:@"%@ %@\n%@\n%@", kLangLevel, floor.name, building.name, venue.name], @"icon": [self materialIcon:VCMaterialDesignIconCode.md_city]}];
                    }
                    
                    [self.tableView reloadData];
                }];
            }
        } else if (venue) {
            [_fields addObject:@{@"type": @"place", @"text": venue.name, @"icon": [self materialIcon:VCMaterialDesignIconCode.md_city]}];
            [self.tableView reloadData];
        } else {
            [self.tableView reloadData];
        }
        
        if (headerImageUrl && headerImageUrl.length > 7) {
            [self.headerImageView mp_setImageWithURL:headerImageUrl placeholderImageName:@"placeholder"];
        }
    }

    __weak typeof(self)weakSelf = self;
    [self mp_onContentSizeChange:^(DynamicTextSize dynamicTextSize) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.titleLabel.font = [AppFonts sharedInstance].headerTitleFont;
        UIButton* routeBtn = strongSelf->_routeBtn;
        routeBtn.titleLabel.font = [AppFonts sharedInstance].buttonFont;
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = CGRectMake(0, 0, 600, 184);
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f] CGColor], nil];
    gradient.startPoint = CGPointMake(0, .5f);
    gradient.endPoint = CGPointMake(0, 1.0f);
    
    CAGradientLayer *gradientTop = [CAGradientLayer layer];
    gradientTop.frame = CGRectMake(0, 0, 600, 184);
    gradientTop.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor], (id)[[UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f] CGColor], nil];
    gradientTop.startPoint = CGPointMake(0, 0.4f);      // Elsewhere we use (0.2f, 0.4f)... using (0, 0.4f) here is intentional, allowing the right barbutton item to be seen on all backgrounds.
    gradientTop.endPoint = CGPointMake(0, 0);
    
    [self.headerImageView.layer insertSublayer:gradient atIndex:0];
    [self.headerImageView.layer insertSublayer:gradientTop atIndex:1];
    
    [self reloadLocationData];
    [self showSpinnerIfNeeded];

    __weak typeof(self)weakSelf = self;
    [self mp_onReachabilityChange:^(BOOL isNetworkReachable) {
        if ( isNetworkReachable ) {
            if ( weakSelf.route == nil ) {
                [weakSelf reloadLocationData];
            }
        } else {
            [weakSelf.tableView reloadSections:[NSIndexSet indexSetWithIndex:DetailSection_OfflineMessage] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (_showMapBtn == nil) {
        _showMapBtn = [UIButton appRectButtonWithTitle:kLangShowOnMap target:self selector:@selector(showMapController:)];
        [_showMapBtn setTitleColor:[UIColor appPrimaryTextColor] forState:UIControlStateNormal];
        _showMapBtn.backgroundColor = [UIColor appTextAndIconColor];
        _showMapBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        
        _routeBtn = [UIButton appRectButtonWithTitle:kLangGetDirections target:self selector:@selector(showDirectionsController:)];
        
        [self.tableFooter addSubview:_showMapBtn];
        [self.tableFooter addSubview:_routeBtn];
        
        [_showMapBtn configureForAutoLayout];
        [_showMapBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft];
        [_showMapBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_showMapBtn autoSetDimension:ALDimensionHeight toSize:40];
        [_showMapBtn autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.tableFooter withMultiplier:0.5];

        [_routeBtn configureForAutoLayout];
        [_routeBtn autoPinEdgeToSuperviewEdge:ALEdgeRight];
        [_routeBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        [_routeBtn autoSetDimension:ALDimensionHeight toSize:40];
        [_routeBtn autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.tableFooter withMultiplier:0.45];
    }
}

- (void) showMapController:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseRouting" object:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowLocationOnMap" object:_location];
    
    BOOL    isIPad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
    if ( isIPad == NO ) {
        
        UIBarButtonItem* btn = self.splitViewController.displayModeButtonItem;
        [[UIApplication sharedApplication] sendAction:btn.action
                                                   to:btn.target
                                                 from:nil
                                             forEvent:nil];
    }
    
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:NO];
}

- (void) showDirectionsController:(id)sender {
    
    if ([self shouldPerformSegueWithIdentifier:@"DirectionsSegue" sender:self]) {
        [self performSegueWithIdentifier:@"DirectionsSegue" sender:self];
    }
    
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:NO];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return DetailSection_Count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger nRows = 0;

    switch ( (DetailSection)section ) {
        case DetailSection_LocationDetails:
            nRows = _fields.count;
            break;
        case DetailSection_OfflineMessage:
            nRows = self.mp_isNetworkReachable || self.route ? 0 : 1;
            break;
        case DetailSection_Booking:
            if ( self.bookingDetailsViewModel.shouldShowBookingInformation ) {
                nRows = 1 + self.bookingDetailsViewModel.bookingEntries.count;
                if ( self.bookingDetailsViewModel.error ) {
                    ++nRows;
                }
            }
            break;
        case DetailSection_Count:
            break;
    }
    return nRows;
}

- (UIImage*) materialIcon:(NSString*)iconCode {
    // create icon with Material Design code and font size
    // font size is the basis for icon size
    VCMaterialDesignIcons *icon = [VCMaterialDesignIcons iconWithCode:iconCode fontSize:36.f];
    
    // add attribute to icon
    [icon addAttribute:NSForegroundColorAttributeName value:[UIColor appPrimaryColor]];
    
    // the icon will be drawn to UIImage in a given size
    return [icon image];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell*    cell;
    
    switch ( (DetailSection)indexPath.section ) {

        case DetailSection_LocationDetails: {
            NSDictionary*           dict = (indexPath.row < _fields.count) ? [_fields objectAtIndex:indexPath.row] : @{};
            DetailsTableViewCell*   detailsCell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
            UIImage*                img = [dict objectForKey:@"icon"];
            id                      title = [dict objectForKey:@"text"];
            NSString*               subTitle;
            
            if ([[dict objectForKey:@"type"] isEqualToString:@"directions"]) {
                subTitle = self.subTitleForDirectionsCell;
            }
            
            [detailsCell configureWithTitle:title subTitle:subTitle image:img];
            
            cell = detailsCell;
            
            break;
        }
            
        case DetailSection_OfflineMessage: {
            DetailsTableViewCell*   detailsCell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
            UIImage*                img = [self materialIcon:VCMaterialDesignIconCode.md_cloud_off];
            NSString*               title = kLangOfflineTryToReconnect;
            
            [detailsCell configureWithTitle:title titleColor:[UIColor appTertiaryHighlightColor] image:img imageTintColor:[UIColor lightGrayColor]];
            detailsCell.showSeparator = YES;
            detailsCell.showActivityIndicator = [self shouldShowSpinner];
            
            cell = detailsCell;
            break;
        }

        case DetailSection_Booking:
            if ( indexPath.row == 0 ) {
                DetailsTableViewCell*   detailsCell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
                // UIImageSymbolConfiguration* config = [UIImageSymbolConfiguration configurationWithPointSize:24];
                // UIImage*                image = [UIImage systemImageNamed:@"calendar.badge.plus" withConfiguration:config];
                UIImage*    image = [UIImage imageNamed:@"booking-calendar"];
                NSString*               title = NSLocalizedString(@"Book",);

                [detailsCell configureWithTitle:title titleColor:[UIColor appPrimaryTextColor] image:image imageTintColor:[UIColor appPrimaryColor]];
                detailsCell.showActivityIndicator = self.bookingDetailsViewModel.isBusy;

                UISegmentedControl*     durationSelector = [[UISegmentedControl alloc] initWithItems: self.bookingDetailsViewModel.availableDurations];
                durationSelector.selectedSegmentIndex = self.bookingDetailsViewModel.selectedDurationIndex;
                [durationSelector addTarget:self action:@selector(onBookingDurationChanged:) forControlEvents:UIControlEventValueChanged];
                [durationSelector sizeToFit];
                CGRect r = durationSelector.frame;
                r.size.width += 8;
                durationSelector.frame = r;
                detailsCell.accessoryView = durationSelector;

                cell = detailsCell;

            } else if ( indexPath.row <= self.bookingDetailsViewModel.bookingEntries.count ) {

                BookingDetailsEntry*    bookingEntry = self.bookingDetailsViewModel.bookingEntries[ indexPath.row -1 ];

                UIImage*    image = [UIImage new];
                NSString*   cellTitle = bookingEntry.descriptionText;
                NSString*   actionTitle;
                UIColor*    actionTitleColor = UIColor.lightGrayColor;
                UIFont*     actionFont = [AppFonts sharedInstance].listItemFont;

                UIButton*       actionButton = [UIButton new];
                if ( bookingEntry.isBookable ) {
                    if ( !bookingEntry.bookingInProgress ) {
                        actionTitle = NSLocalizedString(@"Book",);
                        actionTitleColor = [UIColor appPrimaryColor];
                        actionFont = [AppFonts.sharedInstance scaledBoldFontForSize:15];
                    } else {
                        actionTitle = NSLocalizedString(@"Booking",);
                    }
                } else if ( bookingEntry.isCancellable ) {
                    actionTitle = bookingEntry.bookingInProgress ? NSLocalizedString(@"Cancelling",) : NSLocalizedString(@"Cancel",);
                    actionTitleColor = bookingEntry.bookingInProgress ? UIColor.lightGrayColor : UIColor.redColor;
                } else {
                    actionTitle = NSLocalizedString( @"Booked", );
                }

                DetailsTableViewCell*   detailsCell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
                [detailsCell configureWithTitle:cellTitle titleColor:[UIColor appPrimaryTextColor] image:image imageTintColor:[UIColor appPrimaryColor]];
                detailsCell.compactHeight = YES;
                detailsCell.accessoryView = actionButton;
                detailsCell.showActivityIndicator = bookingEntry.bookingInProgress;
                [actionButton setTitle:actionTitle forState:UIControlStateNormal];
                [actionButton.titleLabel setFont:actionFont];
                [actionButton setTitleColor:actionTitleColor forState:UIControlStateNormal];
                [actionButton sizeToFit];
                actionButton.mp_userInfo = bookingEntry;
                actionButton.tag = indexPath.row;
                [actionButton addTarget:self action:@selector(handleBookingAction:) forControlEvents:UIControlEventTouchUpInside];

                cell = detailsCell;

            } else if ( indexPath.row == (self.bookingDetailsViewModel.bookingEntries.count +1) ) {

                DetailsTableViewCell*   detailsCell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
                NSString*               title = [NSString stringWithFormat: NSLocalizedString( @"Oops - something went wrong getting the calendar for %@",), self.location.name];
                NSString*               message = self.bookingDetailsViewModel.error.localizedDescription;

                if ( message.length ) {
                    title = [title stringByAppendingFormat:@":\n%@", message];
                }

                [detailsCell configureWithTitle:title titleColor:[UIColor appPrimaryTextColor] image:[UIImage new] imageTintColor:[UIColor appPrimaryColor]];

                cell = detailsCell;
            }
            break;

        case DetailSection_Count:       // Only here for completeness, so Xcode will warn if/when adding new sections to enum
            break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch ( (DetailSection)indexPath.section ) {
            
        case DetailSection_LocationDetails: {
            NSDictionary* dict = [_fields objectAtIndex:indexPath.row];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DetailFieldTapped" object:dict];
            break;
        }
            
        case DetailSection_OfflineMessage: {
            DetailsTableViewCell*   cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.showActivityIndicator = YES;
            [self reloadLocationData];
            break;
        }

        case DetailSection_Booking:
        case DetailSection_Count:
            break;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    
    NSIndexPath*    indexPathForSelectedRow = self.tableView.indexPathForSelectedRow;
    
    if ( indexPathForSelectedRow ) {
        
        if ( indexPathForSelectedRow.section == DetailSection_LocationDetails ) {
            NSDictionary* dict = [_fields objectAtIndex:indexPathForSelectedRow.row];
            
            if (![[dict objectForKey:@"type"] isEqualToString:@"directions"]) {
                
                return NO;
            }
            
        } else if ( (indexPathForSelectedRow.section == DetailSection_OfflineMessage) || (indexPathForSelectedRow.section == DetailSection_Booking)) {
            return NO;
        }
    }
    
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DirectionsController *directions = [segue destinationViewController];
    
    if ([segue.identifier isEqualToString:@"DirectionsSegue"]) {
        
        // Checking location services status for Directions Controller.
        directions.isLocationServicesOn = [MapsIndoors.positionProvider isRunning];
        #if defined(MI_SDK_VERSION_MAJOR) && (MI_SDK_VERSION_MAJOR >= 2)
            directions.isLocationServicesOn = MapsIndoors.positionProvider.locationServicesActive;
        #endif
    }
}

- (void)onRouteResultReady:(NSNotification *)notification {

    self.route = notification.object;
    if ( self.route ) {
        
        NSArray<SectionModel*>* routeSections = [self.route sectionModelsForRequestTravelMode:[_routing.travelMode convertTo_TRAVEL_MODE]];
        MPDirectionsViewModel*  directionsViewModel = [MPDirectionsViewModel newWithRoute:self.route routingData:_routing models:routeSections];
        NSString*               overallTravelMode = _routing.travelMode;
        NSArray<NSNumber*>* travelModes = directionsViewModel.travelModes;
        if ( travelModes.count == 1 ) {
            TRAVEL_MODE     usedTravelMode = (TRAVEL_MODE)[travelModes.firstObject unsignedIntegerValue];
            overallTravelMode = [NSString stringFromTravelMode:usedTravelMode];
        }

        NSAttributedString* directionsInfo = [Global isUnlikelyDuration:self.route.duration.doubleValue]
                                           ? [[NSAttributedString alloc] initWithString: @"Duration estimate not available"]
                                           : [Global localizedStringForDuration: [self.route.duration floatValue] travelMode:overallTravelMode];
        
        if (_from) {
            //TODO set name with builder instead
            //_from.name = directionsInfo.string;
        }
        NSDictionary* directionsItem = @{@"type": @"directions", @"text": directionsInfo, @"icon": [self materialIcon:VCMaterialDesignIconCode.md_walk]};
        
        NSPredicate* findDirectionsItem = [NSPredicate predicateWithFormat:@"type == 'directions'"];
        NSArray* foundDirectionsItems = [_fields filteredArrayUsingPredicate:findDirectionsItem];
        if (foundDirectionsItems.count > 0) {
            [_fields removeObject:foundDirectionsItems.firstObject];
        }
        [_fields insertObject:directionsItem atIndex:0];
        
        [self.tableView reloadData];
    }
    
    [self endOperation:@"routingFrom"];
}


#pragma mark - Async operation management

- (BOOL) beginOperation:(NSString*)opName {
    
    if ( [self.operationsInProgress containsObject:opName] == NO ) {
        [self.operationsInProgress addObject:opName];
        [self showSpinnerIfNeeded];
        return YES;
    }
    return NO;
}

- (void) endOperation:(NSString*)opName {
    
    [self.operationsInProgress removeObject:opName];
    [self showSpinnerIfNeeded];
}


#pragma mark - Booking support


- (void) reloadBookingsList {

    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:DetailSection_Booking] withRowAnimation:UITableViewRowAnimationAutomatic];
}


- (void) setBookingDetailsViewModel:(BookingDetailsViewModel*)bookingDetailsViewModel {

    if ( _bookingDetailsViewModel ) {
        [self.KVOController unobserve:_bookingDetailsViewModel];
    }

    _bookingDetailsViewModel = bookingDetailsViewModel;

    if ( _bookingDetailsViewModel ) {
        [_bookingDetailsViewModel refresh];
        
        [self.KVOController observe:_bookingDetailsViewModel keyPath:@"isBusy" options:NSKeyValueObservingOptionNew block:^(DetailViewController* _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
            [observer reloadBookingsList];
        }];
    }
}


- (void) onBookingDurationChanged:(UISegmentedControl*)sender {
    
    self.bookingDetailsViewModel.selectedDurationIndex = sender.selectedSegmentIndex;
    
    // Avoid text truncation in the segmented control titles. Credits https://stackoverflow.com/a/19823102:
    for ( int i=0; i < sender.numberOfSegments; ++i ) {
        NSString* segmentTitle = [sender titleForSegmentAtIndex:i];
        [sender setTitle:segmentTitle forSegmentAtIndex:i];
    }
}


- (void) handleBookingAction:(UIButton*)sender {

    id                      thing = sender.mp_userInfo;

    if ( [thing isKindOfClass:BookingDetailsEntry.class] ) {

        BookingDetailsEntry*    bookingEntry = thing;

        if ( bookingEntry.bookingInProgress == NO ) {

            if ( bookingEntry.isBookable ) {

                [self.bookingDetailsViewModel performBooking:bookingEntry completion:^(BookingDetailsEntry *entry, NSError *error) {

                    if ( error ) {
                        NSLog( @"[E] Error booking %@ from %@ to %@ (%@)", self.location.name, bookingEntry.startTime, bookingEntry.endTime, error );
                    }
                    [self reloadBookingsList];
                }];

            } else if ( bookingEntry.isCancellable ) {

                [self.bookingDetailsViewModel cancelBooking:bookingEntry completion:^(BookingDetailsEntry *entry, NSError *error) {

                    if ( error ) {
                        NSLog( @"[E] Error cancelling booking %@ from %@ to %@ (%@)", self.location.name, bookingEntry.startTime, bookingEntry.endTime, error );
                    }
                    [self reloadBookingsList];
                }];

            }

            [self.tableView reloadRowsAtIndexPaths:@[ [NSIndexPath indexPathForRow:sender.tag inSection:DetailSection_Booking] ] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}


@end
