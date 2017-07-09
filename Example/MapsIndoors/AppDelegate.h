//
//  AppDelegate.h
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 10/08/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#define kMapsIndoorsSolutionId @"550c26a864617400a40f0000"                  // ADD YOUR OWN MAPSINDOORS SOLUTION ID
#define kVenue @"rtx"                                                       // OPTIONALLY ADD A VENUE NAME
//ADD_YOUR_OWN_GOOGLE_MAPS_IOS_API_KEY
#define kGoogleMapsApiKey @"ADD_YOUR_OWN_GOOGLE_MAPS_IOS_API_KEY"           // ADD YOUR OWN GOOGLE MAPS IOS API KEY
//ADD_YOUR_OWN_GOOGLE_DIRECTIONS_API_KEY
#define kGoogleDirectionsApiKey @"ADD_YOUR_OWN_GOOGLE_MAPS_IOS_API_KEY"   // ADD YOUR OWN GOOGLE MAPS DIRECTIONS API KEY

// If you don't have a Google Maps API, here is how you do it:
// Create a project: https://console.developers.google.com/projectcreate
// Enable the APIs here: https://console.developers.google.com/apis/library
// You will need to enable Google Maps iOS SDK, Directions API and Distance Matrix API
// Create API keys here: https://console.developers.google.com/apis/credentials
// You can use one API key for all APIs if the key is unrestricted

#import <UIKit/UIKit.h>
#import <MapsIndoors/MapsIndoors.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController* navigationController;
@property (strong, nonatomic) NSString* locationIdToOpen;

@end

