//
//  AppDelegate.h
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 10/08/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

//#define kMapsIndoorsSolutionId @"550c26a864617400a40f0000"                  //ADD YOUR OWN MAPSINDOORS SOLUTION ID
//#define kVenue @"rtx"                                                       //OPTIONALLY ADD A VENUE NAME
//#define kGoogleMapsApiKey @"AIzaSyDwkz2YVlxoJnjhSMRp_qsLlBXLgQEArAc"        //ADD YOUR OWN GOOGLE MAPS IOS API KEY
//ADD_YOUR_OWN_GOOGLE_DIRECTIONS_API_KEY
//#define kGoogleDirectionsApiKey @"ADD_YOUR_OWN_GOOGLE_DIRECTIONS_API_KEY"   //ADD YOUR OWN GOOGLE MAPS DIRECTIONS API KEY

#define kMapsIndoorsSolutionId @"571741723fcacf08b44d7a50" // 550c26a864617400a40f0000"                  //ADD YOUR OWN MAPSINDOORS SOLUTION ID
#define kVenue @"Wideco Sweden AB"                                                       //OPTIONALLY ADD A VENUE NAME
#define kGoogleMapsApiKey @"AIzaSyDwkz2YVlxoJnjhSMRp_qsLlBXLgQEArAc" // AIzaSyDwkz2YVlxoJnjhSMRp_qsLlBXLgQEArAc"        //ADD YOUR OWN GOOGLE MAPS IOS API KEY
#define kGoogleDirectionsApiKey @"AIzaSyDwkz2YVlxoJnjhSMRp_qsLlBXLgQEArAc"   //ADD YOUR OWN GOOGLE MAPS DIRECTIONS API KEY

#import <UIKit/UIKit.h>
#import <MapsIndoors/MapsIndoors.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>


@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController* navigationController;
@property (strong, nonatomic) NSString* locationIdToOpen;

@end

