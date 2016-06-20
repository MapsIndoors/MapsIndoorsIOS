//
//  AppDelegate.m
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 10/08/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//


#import "AppDelegate.h"
#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "ContainerViewController.h"
#import "Global.h"
#import "UIColor+AppColor.h"
#import "RoutingData.h"
#import "UIFont+SystemFontOverride.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GMSServices provideAPIKey:kGoogleMapsApiKey];
    
    Global.solutionId = kMapsIndoorsSolutionId;
    Global.venue = kVenue;
    Global.initialPosition = [[MPPoint alloc] initWithLat:57.085771 lon:9.957593 zValue:0];
    
    Global.poiData = [[POIData alloc] init];
    Global.routingData = [[RoutingData alloc] initWithMapsIndoorsSolutionId: kMapsIndoorsSolutionId googleApiKey:kGoogleDirectionsApiKey];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocationDetailTapped:) name:@"DetailFieldTapped" object:nil];
    
    [[UILabel appearance] setFont:[UIFont systemFontOfSize:15]];
    
    
    // Override point for customization after application launch.
    UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
    self.navigationController = [splitViewController.viewControllers lastObject];
    self.navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    splitViewController.delegate = self;
    
    ContainerViewController* containerViewController = [[ContainerViewController alloc] init];
    
    [containerViewController setEmbeddedViewController: splitViewController];
    
    self.window.rootViewController = containerViewController;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Split view


- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    //navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
    
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[MapViewController class]] && ([(MapViewController *)[(UINavigationController *)secondaryViewController topViewController] detailLocation] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return NO;
    } else {
        return NO;
    }
}

- (void) onLocationDetailTapped: (NSNotification*) notification {
    NSDictionary* field = notification.object;
    NSString* fieldType = [field objectForKey:@"type"];
    NSString* val = [field objectForKey:@"text"];
    if ([fieldType isEqualToString:@"website"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:val]];
    }
    if ([fieldType isEqualToString:@"phone"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat: @"tel://%@", val]]];
    }
    if ([fieldType isEqualToString:@"email"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat: @"mailto://%@", val]]];
    }
}

@end
