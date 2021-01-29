//
//  MasterNavigationController.m
//  MIAIOS
//
//  Created by Daniel Nielsen on 30/09/15.
//  Copyright © 2015-2018 MapsPeople A/S. All rights reserved.
//

#import "MasterNavigationController.h"
#import "DetailViewController.h"
#import "DirectionsController.h"
#import "Global.h"
#import "AppDelegate.h"
#import "UIColor+AppColor.h"
#import <MapsIndoors/MapsIndoors.h>
#import "VenueSelectorController.h"
#import "LocalizationSystem.h"
@import VCMaterialDesignIcons;
#import "UIViewController+Custom.h"
#import "LocalizedStrings.h"
#import "TCFKA_MDSnackbar.h"
#import "AppNotifications.h"


@interface MasterNavigationController () <UINavigationControllerDelegate>

@property (nonatomic, strong) NSDictionary*     routeRequestParameters;

@end


@implementation MasterNavigationController {
    NSUserDefaults* _prefs;
    BOOL _visible;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMapLocationTapped:) name:@"MapLocationTapped" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocationOpened:) name:@"LocationOpen" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRouteRequested:) name:AppNotifications.routeRequestNotificationName object:nil];

    self.delegate = self;
    
    NSString* locToOpen = ((AppDelegate*)[UIApplication sharedApplication].delegate).locationIdToOpen;
    if (locToOpen) {
        [self performSelector:@selector(openLocationWithId:) withObject:locToOpen afterDelay:1.0];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _visible = false;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _visible = true;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ( [segue.identifier isEqualToString:@"DetailSegue"] && (sender == self) ) {

        DetailViewController* vc = segue.destinationViewController;
        vc.location = nil;

    } else if ( [segue.identifier isEqualToString:@"RouteRequestSegue"] ) {

        DirectionsController*   vc = segue.destinationViewController;
        [vc configureWithRouteFrom: self.routeRequestParameters[ AppNotifications.routeRequestOriginKey ]
                                to: self.routeRequestParameters[ AppNotifications.routeRequestDestinationKey ]
                        travelMode: self.routeRequestParameters[ AppNotifications.routeRequestTravelModeKey ]
                            avoids: self.routeRequestParameters[ AppNotifications.routeRequestAvoidsKey ]
        ];

        self.routeRequestParameters = nil;
    }
}

- (void)onMapLocationTapped:(NSNotification*)notification {
    
    MPLocation* loc = notification.object;
    
    [self openLocationWithId:loc.locationId];
}

- (void)onLocationOpened:(NSNotification*)notification {
    
    NSString* locId = notification.object;
    
    [self openLocationWithId:locId];
}

- (void)openSidebar {
    if ( !_visible && self.splitViewController.displayMode != UISplitViewControllerDisplayModeAllVisible ) {
        UIBarButtonItem* btn = self.splitViewController.displayModeButtonItem;
        [[UIApplication sharedApplication] sendAction:btn.action
                                                   to:btn.target
                                                 from:nil
                                             forEvent:nil];
    }
}

- (void)openLocationWithId:(NSString*)locationId {

    [self.topViewController popToMasterViewControllerAnimated:NO];
    [self performSegueWithIdentifier:@"DetailSegue" sender:self];
    
    [self openSidebar];
    
    [MapsIndoors.locationsProvider getLocationWithId:locationId completionHandler:^(MPLocation *location, NSError *error) {
        if (location) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationDetailsReady" object:location];
        } else if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                TCFKA_MDSnackbar* bar = [[TCFKA_MDSnackbar alloc] initWithText:kLangCouldNotFindLocationDetails actionTitle:@"" duration:4.0];
                [bar show];
            });
        }
    }];
}

- (void) onRouteRequested:(NSNotification*)notification {

    self.routeRequestParameters = notification.userInfo;

    [self.topViewController popToMasterViewControllerAnimated:NO];
    [self performSegueWithIdentifier:@"RouteRequestSegue" sender:self];

    [self openSidebar];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSideMenuWillNavigate object:self];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
 
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationSideMenuDidNavigate object:self];
}

@end
