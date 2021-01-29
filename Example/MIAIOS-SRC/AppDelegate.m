//
//  AppDelegate.m
//  MIAIOS
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
#import "LocalizationSystem.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import "Tracker.h"
#import "MPGooglePlacesClient.h"
#import "MPSVGImageProvider.h"
#import "NSObject+CustomIntegrations.h"
#import "AppVariantData.h"
//#import "SimulatedPeopleLocationSource.h"
#import "MPUrlSchemeHelper.h"
#import "AppFlowController.h"
#import "AppPositionProvider.h"


@interface AppDelegate () <UISplitViewControllerDelegate>

@property (nonatomic, strong) CLLocationManager*    locationManager;
@property (nonatomic) BOOL                          isPositionProviderStoppedWhenInBackground;
@property (nonatomic) BOOL                          shouldSynchronizeDataOnAppActivation;

@end

@interface MPMIAPI (DevEnv)

@property (nonatomic, readwrite) BOOL useDevEnvironment;
+ (MPMIAPI*) sharedInstance;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.isPositionProviderStoppedWhenInBackground = NO;
    
    MapsIndoors.imageProvider =  [MPSVGImageProvider new];
    
    [self applyCustomIntegrations];
    
    NSString* overrideLanguage = [[[NSProcessInfo processInfo] environment] objectForKey:@"MI_LANGUAGE"];
    
    [GMSServices provideAPIKey:[Global getPropertyFromPlist:@"GoogleAPIKey"]];
    [MPGooglePlacesClient provideAPIKey:[Global getPropertyFromPlist:@"GoogleAPIKey"]];
    
    NSString*   googleServiceInfoPlist = [[NSBundle mainBundle] pathForResource:@"GoogleService-Info" ofType:@"plist"];
    Tracker.disabled = [[NSFileManager defaultManager] fileExistsAtPath:googleServiceInfoPlist] == NO;
    [Tracker setup];

    if ( overrideLanguage ) {
        LocalizationSetLanguage( overrideLanguage );
    } else {
        [MapsIndoors setLanguage:LocalizationGetLanguage];  // Start MapsIndoors with UI language, when solution is loaded the MapsIndoors-language may change if the UI language is not supported by the solution data.
    }
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

    self.shouldSynchronizeDataOnAppActivation = self.delayedMapsIndoorsInit == NO;
    if ( self.delayedMapsIndoorsInit == NO ) {
        [MapsIndoors provideAPIKey:[AppVariantData sharedAppVariantData].mapsIndoorsAPIKey googleAPIKey:[AppVariantData sharedAppVariantData].googleAPIKey];
    }
    
//    #ifdef BUILDING_SDK_APP
//        [MapsIndoors registerLocationSources:@[ [MPMapsIndoorsLocationSource new], [SimulatedPeopleLocationSource new]]];
//    #endif

    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    Global.routingData = [RoutingData new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocationDetailTapped:) name:@"DetailFieldTapped" object:nil];
    
    [[UILabel appearance] setFont:[UIFont systemFontOfSize:15]];
    
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;

    if ( self.delayedMapsIndoorsInit == NO ) {
        [MPNotificationsHelper setupNotificationsForApp:[UIApplication sharedApplication] withLocationManager:self.locationManager];
    }
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

    [MapsIndoors.positionProvider updateLocationPermissionStatus];

    if (self.isPositionProviderStoppedWhenInBackground) {
        [MapsIndoors.positionProvider startPositioning:nil];
    }

    if ( self.shouldSynchronizeDataOnAppActivation ) {

        [MapsIndoors synchronizeContent:^(NSError *error) {
            // Additional tasks and error handling/reporting could be done here.
        }];

    } else {

        self.shouldSynchronizeDataOnAppActivation = YES;
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

    BOOL    bStopPositioning = YES;

    if ( [MapsIndoors.positionProvider conformsToProtocol:@protocol(AppPositionProvider)] ) {
        id<AppPositionProvider>     appPositionProvider = (id<AppPositionProvider>)MapsIndoors.positionProvider;
        bStopPositioning = appPositionProvider.backgroundLocationUpdates ? NO : YES;
    }

    if ( bStopPositioning ) {
        [MapsIndoors.positionProvider stopPositioning:nil];
        self.isPositionProviderStoppedWhenInBackground = YES;
    }
}

- (void) onLocationDetailTapped: (NSNotification*) notification {
    
    NSDictionary* field = notification.object;
    NSString* fieldType = [field objectForKey:@"type"];
    NSString* val = [field objectForKey:@"text"];
    
    if ([fieldType isEqualToString:@"website"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:val] options:@{} completionHandler:nil];
    }
    if ([fieldType isEqualToString:@"phone"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat: @"tel://%@", val]] options:@{} completionHandler:nil];
    }
    if ([fieldType isEqualToString:@"email"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat: @"mailto://%@", val]] options:@{} completionHandler:nil];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    Global.appSchemeLocationQuery = nil;
}

- (BOOL) application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    
    BOOL    result = YES;

    if ( !self.openUrlHook || !self.openUrlHook( app, url, options ) ) {

        MPUrlSchemeHelper*  urlSchemeHelper = [MPUrlSchemeHelper new];
        if ( [urlSchemeHelper parseUrl:url.absoluteString] ) {

            switch ( urlSchemeHelper.command ) {
                case MPUrlSchemeCommand_LocationDetails:
                    [[AppFlowController sharedInstance] presentDetailsScreenForLocationWitId:urlSchemeHelper.location];
                    break;

                case MPUrlSchemeCommand_Directions:
                    [[AppFlowController sharedInstance] presentRouteFrom:urlSchemeHelper.origin
                                                            fromLocation:urlSchemeHelper.originLocation
                                                                      to:urlSchemeHelper.destination
                                                              toLocation:urlSchemeHelper.destinationLocation
                                                              travelMode:urlSchemeHelper.travelMode
                                                                   avoid:urlSchemeHelper.avoids];
                    break;

                case MPUrlSchemeCommand_Unknown:
                    break;
            }

        } else {

            NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];

            NSArray *queryItems = urlComponents.queryItems;
            NSString *venue = [self valueForKey:@"venueId" fromQueryItems:queryItems];
            if (venue) {
                MPVenueProvider* venues = [[MPVenueProvider alloc] init];
                [venues getVenueWithId:venue completionHandler:^(MPVenue *venue, NSError *error) {
                    if (error == nil) {
                        Global.venue = venue;
                    }
                }];
            }

            MPLocationQuery* lq = [MPLocationQuery queryWithUrl:url];
            if (lq) {
                Global.appSchemeLocationQuery = lq;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"OpenLocationSearch" object:lq];
            }

            NSString *locationId = [self valueForKey:@"locationId" fromQueryItems:queryItems];
            if (locationId && locationId.length == 24) {
                [MapsIndoors.locationsProvider getLocationWithId:locationId];
            }

            NSString *initialPos = [self valueForKey:@"center" fromQueryItems:queryItems];
            if (initialPos) {
                NSArray* posArr = [initialPos componentsSeparatedByString:@","];
                Global.initialPosition = [[MPPoint alloc] initWithLat:[[posArr objectAtIndex:0] doubleValue] lon:[[posArr objectAtIndex:1] doubleValue]];
            }
        }

        [MPNotificationsHelper setupNotificationsForApp:[UIApplication sharedApplication] withLocationManager:self.locationManager];
    }

    return result;
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

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    [MPNotificationsHelper fetchMessagesForSolution:[MapsIndoors getMapsIndoorsAPIKey] completionHandler:completionHandler messageHandler:^(MPMessage * message) {
        [MPNotificationsHelper monitorRegionForMessage:message withLocationManager:self->_locationManager];
    }];
}

//- (void) openLocationSearch: (MPLocationQuery*) locationQuery {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationSearch" object:locationQuery];
//}


#pragma mark - CLLocationManagerDelegate

- (void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    // Region monitoring is only available with "Always" authorization (See doc for -[CLLocationManager requestWhenInUseAuthorization]):
    switch ( status ) {
        case kCLAuthorizationStatusAuthorizedAlways: {
            [MPNotificationsHelper setupNotificationsForApp:[UIApplication sharedApplication] withLocationManager:self.locationManager];
            [MPNotificationsHelper fetchMessagesForSolution:[MapsIndoors getMapsIndoorsAPIKey] completionHandler:nil messageHandler:^(MPMessage * message) {
                [MPNotificationsHelper monitorRegionForMessage:message withLocationManager:self.locationManager];
            }];
            NSLog( @"[I] 'Always' location permission granted" );
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            if ( [Global.solution.modules containsObject:@"messages"] ) {
                NSLog( @"[W] User allowed only 'WhenInUse' location permission - Beacon monitoring and messages are not available" );
            } else {
                NSLog( @"[I] 'WhenInUse' location permission granted" );
            }
            break;
        case kCLAuthorizationStatusDenied:
            NSLog( @"[W] User denied location permission - Beacon monitoring and messages are not available" );
            break;
        case kCLAuthorizationStatusNotDetermined:
            NSLog( @"[W] Waiting to determine CLAuthorizationStatus" );
            break;
        case kCLAuthorizationStatusRestricted:
            NSLog( @"[W] Device is restricted to *not* allow location services to this app - Beacon monitoring and messages are not available" );
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    [MPNotificationsHelper locationManager:manager didEnterRegion:region];
}


#pragma mark - UNUserNotificationCenterDelegate

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    self.locationIdToOpen = [response.notification.request.content.userInfo objectForKey:@"locationId"];
    if (self.locationIdToOpen) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationOpen" object:self.locationIdToOpen];
    }
}

@end
