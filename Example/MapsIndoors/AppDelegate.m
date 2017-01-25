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
#import "NotificationsHelper.h"
#import "LocalizationSystem.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate {
    NSMutableArray* _messages;
    CLLocationManager* _locationManager;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GMSServices provideAPIKey:kGoogleMapsApiKey];
    
    //Demo venue credentials - adapt these data to your needs
    Global.solutionId = kMapsIndoorsSolutionId; //Rtx test solution
    Global.initialPosition = [[MPPoint alloc] initWithLat:57.0858357 lon:9.9573986 zValue:0];
    
    
    Global.poiData = [[POIData alloc] init];
    Global.routingData = [[RoutingData alloc] initWithMapsIndoorsSolutionId: Global.solutionId googleApiKey:kGoogleDirectionsApiKey];
    
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
    
    UILocalNotification *localNotif =
    [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
        self.locationIdToOpen = [localNotif.userInfo objectForKey:@"locationId"];
    }
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [MPNotificationsHelper setupNotificationsForApp:application withLocationManager:_locationManager];
    [MPNotificationsHelper fetchMessagesForSolution:Global.solutionId completionHandler:nil messageHandler:^(MPMessage * message) {
        [MPNotificationsHelper monitorRegionForMessage:message withLocationManager:_locationManager];
    }];
    return YES;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [MPNotificationsHelper fetchMessagesForSolution:Global.solutionId completionHandler:completionHandler messageHandler:^(MPMessage * message) {
        [MPNotificationsHelper monitorRegionForMessage:message withLocationManager:_locationManager];
    }];
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [MPNotificationsHelper locationManager:manager didEnterRegion:region];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    UIApplicationState state = [application applicationState];
    if (state == 1)
    {
        self.locationIdToOpen = [notification.userInfo objectForKey:@"locationId"];
        if (self.locationIdToOpen) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationOpen" object:self.locationIdToOpen];
        }
    }
    else if (state == UIApplicationStateInactive)
    {
        //When your app was in background and it got push notification
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [MPNotificationsHelper fetchMessagesForSolution:Global.solutionId completionHandler:nil messageHandler:^(MPMessage * message) {
        [MPNotificationsHelper monitorRegionForMessage:message withLocationManager:_locationManager];
    }];
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

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    //Try this: mapsindoors://map?appColors=262425|161516
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url
                                                resolvingAgainstBaseURL:NO];
    
    NSArray *queryItems = urlComponents.queryItems;
    NSString *solutionId = [self valueForKey:@"solutionId"
                              fromQueryItems:queryItems];
    if (solutionId && solutionId.length == 24) {
        Global.solutionId = solutionId;
    }
    
    Global.poiData = [[POIData alloc] init];
    Global.routingData = [[RoutingData alloc] initWithMapsIndoorsSolutionId: Global.solutionId googleApiKey:@"AIzaSyBh-sdICZSAK8Ecr_DjdV-BEXkqHBU5wtU"];
    
    NSString *venue = [self valueForKey:@"venueId"
                         fromQueryItems:queryItems];
    if (venue) {
        MPVenueProvider* venues = [[MPVenueProvider alloc] init];
        [venues getVenueDetailsAsync:Global.solutionId arg:venue language:LocalizationGetLanguage completionHandler:^(MPVenue *venue, NSError *error) {
            if (error == nil) {
                Global.venue = venue;
            }
        }];
    }
    
    NSString *locationId = [self valueForKey:@"locationId"
                              fromQueryItems:queryItems];
    if (locationId && locationId.length == 24)
        [Global.poiData getLocationDetailsAsync:Global.solutionId withId:locationId language:LocalizationGetLanguage];
    
    NSString *appColors = [self valueForKey:@"appColors"
                             fromQueryItems:queryItems];
    if (appColors) {
        Global.appColors = [appColors componentsSeparatedByString:@"|"];
    }
    
    NSString *initialPos = [self valueForKey:@"center"
                             fromQueryItems:queryItems];
    if (initialPos) {
        NSArray* posArr = [appColors componentsSeparatedByString:@","];
        Global.initialPosition = [[MPPoint alloc] initWithLat:[[posArr objectAtIndex:0] doubleValue] lon:[[posArr objectAtIndex:1] doubleValue]];
    }
    
    if (appColors || solutionId || venue) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Reload" object:nil];
    }
    
    return YES;
}

- (NSString *)valueForKey:(NSString *)key
           fromQueryItems:(NSArray *)queryItems
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", key];
    NSURLQueryItem *queryItem = [[queryItems
                                  filteredArrayUsingPredicate:predicate]
                                 firstObject];
    return queryItem.value;
}

@end
