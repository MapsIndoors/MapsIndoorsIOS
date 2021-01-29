//
//  VenueSelectorController.m
//  MIAIOS
//
//  Created by Daniel Nielsen on 05/07/16.
//  Copyright © 2017-2018 MapsPeople. All rights reserved.
//

#import "VenueSelectorController.h"
#import "Global.h"
#import "UIColor+AppColor.h"
#import "LocalizationSystem.h"
#import "LocalizedStrings.h"
@import VCMaterialDesignIcons;
@import PureLayout;
#import "VenueSelectorCell.h"
#import "Global.h"
#import "UINavigationController+TransparentNavigationController.h"
#import "Tracker.h"
#import "MPAccessibilityHelper.h"
#import "SearchViewController.h"


static NSString* cellIdentifier = @"VenueSelectorCell_Id";


@interface VenueSelectorController ()

@property (nonatomic, weak, readwrite) MPAppData*   appData;
@property (nonatomic)                  BOOL         venueLoadInProgress;

@end


@implementation VenueSelectorController {
    
    NSArray* _venues;
    MPAppDataProvider* _appDataProvider;
    mpVenueSelectBlockType _venueSelectCallback;
    UINavigationBar* _navigationBar;
}

static BOOL _venueSelectorIsShown = NO;

- (MPAppData*) appData {
    return Global.appData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.navigationController.navigationBar.barStyle  = UIBarStyleBlackOpaque;
    self.navigationController.navigationBar.barTintColor =[UIColor appPrimaryColor];
    
    
    self.title = [NSString stringWithFormat:@"%@", kLangSelectVenue];
    
    UINib*  nib = [UINib nibWithNibName:@"VenueSelectorCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    
    [self configureBackButton];
    
    NSString* venueId = [[NSUserDefaults standardUserDefaults] objectForKey:@"venue"];
    if ( venueId ) {

        self.venueLoadInProgress = YES;
        MPVenueProvider*    vp = [MPVenueProvider new];
        [vp getVenueWithId:venueId completionHandler:^(MPVenue *venue, NSError *error) {

            if ( venue ) {
                Global.venue = venue;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"VenueChanged" object:venue];
                if (!Global.appSchemeLocationQuery) {
                    [self performSegueWithIdentifier:@"showMasterControllerNonAnimated" sender:self];
                }
            }

            self.venueLoadInProgress = NO;
        }];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openLocationSearchNotif:) name:@"OpenLocationSearch" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    if (Global.appSchemeLocationQuery) {
        [self performSelector:@selector(openLocationSearch:) withObject:Global.appSchemeLocationQuery afterDelay:1.0];
    }
}

- (void) willEnterForeground {
    if (Global.appSchemeLocationQuery) {
        [self performSelector:@selector(openLocationSearch:) withObject:Global.appSchemeLocationQuery afterDelay:1.0];
    }
}


- (void) configureBackButton {
    
    NSString* venueId = [[NSUserDefaults standardUserDefaults] objectForKey:@"venue"];
    
    if ( venueId ) {
        VCMaterialDesignIcons* icon = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_arrow_left fontSize:28];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:icon.image style:UIBarButtonItemStylePlain target:self action:@selector(exit:)];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
        
    } else {
        
        UIImage* backImg = [UIImage imageNamed:@"ic_location_city_white"];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backImg style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
    }
    
    self.navigationItem.leftBarButtonItem.enabled = (venueId != nil);
    self.navigationItem.leftBarButtonItem.accessibilityHint = kLangExitVenueSelectorAccHint;
}

- (void)exit:(id)sender {
    [self performSegueWithIdentifier:@"showMasterController" sender:self];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [Tracker trackScreen:@"Venues"];
    
    [self.navigationController resetNavigationBar];
    
    MPVenueProvider*_venueProvider = [[MPVenueProvider alloc] init];
    
    [_venueProvider getVenuesWithCompletion:^(MPVenueCollection *venueCollection, NSError *error) {
        
        if ( error ) {
            NSLog( @"%s: error = %@", __PRETTY_FUNCTION__, error );
        }
        
        if ( venueCollection ) {
            
            self->_venues = venueCollection.venues;
            
            [self.tableView reloadData];

            if ( self.venueLoadInProgress == NO ) {
                if (self->_venues.count == 1) {
                    MPVenue*   venue = [self->_venues objectAtIndex:0];
                    if (venue) {
                        [[NSUserDefaults standardUserDefaults] setObject: venue.venueId forKey:@"venue"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"VenueChanged" object:venue];
                    }
                    if (!Global.appSchemeLocationQuery) {
                        [self performSegueWithIdentifier:@"showMasterController" sender:self];
                    }
                }
            }

            [self configureBackButton];
        }
    }];
    
    if ( Global.appData == nil ) {
        _appDataProvider = [[MPAppDataProvider alloc] init];

        [_appDataProvider getAppDataWithCompletion:^(MPAppData *appData, NSError *error) {
            if ( appData ) {
                Global.appData = appData;
                [self.tableView reloadData];
            }
        }];
    }

    self.extendedLayoutIncludesOpaqueBars = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    _venueSelectorIsShown = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationVenueSelectorDidAppear object:self];
    });
}

-  (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];

    _venueSelectorIsShown = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationVenueSelectorDidDisappear object:self];
}

+ (BOOL) venueSelectorIsShown {
    
    return _venueSelectorIsShown;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.tableView.bounds.size.width * 0.5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_venues != nil) {
        return _venues.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VenueSelectorCell*  cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    MPVenue*   venue = [_venues objectAtIndex:indexPath.row];
    NSString*  imageUrl = self.appData ? [self.appData.venueImages objectForKey:venue.venueKey] : nil;
    
    [cell configureWithVenue:venue imageUrl:imageUrl];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MPVenue* venue = [_venues objectAtIndex:indexPath.row];
    if (self.venueSelectDelegate) {
        [self.venueSelectDelegate onVenueSelected:venue];
    }
    if (_venueSelectCallback) {
        _venueSelectCallback(venue);
    }
    
    if ( !self.venueSelectDelegate && !_venueSelectCallback ) {
        MPVenue*   venue = [_venues objectAtIndex:indexPath.row];
        
        if (venue) {
            [[NSUserDefaults standardUserDefaults] setObject:venue.venueId forKey:@"venue"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"VenueChanged" object:venue];
            
            [Tracker trackEvent:@"Venue_Selected" parameters:@{ @"Venue" : venue.venueKey}];
        }
        
        [self performSegueWithIdentifier:@"showMasterController" sender:self];
    }
}

- (void)venueSelectCallback:(mpVenueSelectBlockType)selectCallbackFn {
    _venueSelectCallback = selectCallbackFn;
}

- (void) backPressed {
    if (self.venueSelectDelegate) {
        [self.venueSelectDelegate onVenueSelected:nil];
    }
    if (_venueSelectCallback) {
        _venueSelectCallback(nil);
    }
}

- (void)openLocationSearchNotif:(NSNotification*)notification {
    [self openLocationSearch:notification.object];
}

- (void)openLocationSearch:(MPLocationQuery*)locationQuery {
    
    if (![self.navigationController.viewControllers.lastObject isKindOfClass: [SearchViewController class]]) {
    
        [self.navigationController popToViewController:self animated:NO];
        [self performSegueWithIdentifier:@"SearchSegue" sender:self];
    
    }
    
    [self openSidebar];
    
    [MapsIndoors.locationsProvider getLocationsUsingQuery:locationQuery completionHandler:^(MPLocationDataset * _Nullable locationData, NSError * _Nullable error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationsDataForExternalAppSchemeReady" object:locationData.list];
    }];

}

- (void)openSidebar {
    if ( !self.navigationController.visibleViewController && self.splitViewController.displayMode != UISplitViewControllerDisplayModeAllVisible ) {
        UIBarButtonItem* btn = self.splitViewController.displayModeButtonItem;
        [[UIApplication sharedApplication] sendAction:btn.action
                                                   to:btn.target
                                                 from:nil
                                             forEvent:nil];
    }
}

@end
