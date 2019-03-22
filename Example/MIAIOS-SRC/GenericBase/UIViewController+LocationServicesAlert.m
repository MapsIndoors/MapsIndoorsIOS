//
//  UIViewController+LocationServicesAlert.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 19/04/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import "UIViewController+LocationServicesAlert.h"
@import CoreLocation;
#import "LocalizedStrings.h"
#import "Tracker.h"


@implementation UIViewController (LocationServicesAlert)

- (UIAlertController*) alertControllerForLocationServicesState {
    
    UIAlertController* alert;
    
    if ( [CLLocationManager locationServicesEnabled] == NO ) {
        alert = [UIAlertController alertControllerWithTitle:kLangLocationServicesDisabled
                                                    message:kLangTurnOnLocationServices
                                             preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction*  turnOnBtn = [UIAlertAction actionWithTitle:kLangSettings style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
        }];
        [turnOnBtn setValue:[UIColor redColor] forKey:@"titleTextColor"];
        
        UIAlertAction*  CancelBtn = [UIAlertAction actionWithTitle:kLangCancel style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert addAction:turnOnBtn];
        [alert addAction:CancelBtn];
        
    } else {
        
        switch ( [CLLocationManager authorizationStatus] ) {
            case kCLAuthorizationStatusAuthorizedAlways:
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                break;
                
            case kCLAuthorizationStatusNotDetermined:
#if defined(MI_SDK_VERSION_MAJOR) && (MI_SDK_VERSION_MAJOR >= 2)
                [MapsIndoors.positionProvider requestLocationPermissions];
#endif
                break;
                
            case kCLAuthorizationStatusDenied:
            case kCLAuthorizationStatusRestricted: {
                NSString* appName = [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"] ?: [NSBundle mainBundle].infoDictionary[@"CFBundleName"];
                NSString*   msg = [NSString stringWithFormat:kLangTurnOnLocationServicesForApp,appName];
                
                alert = [UIAlertController alertControllerWithTitle:@""
                                                            message:msg
                                                     preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction*  turnOnBtn = [UIAlertAction actionWithTitle:kLangTurnOn style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
                }];
                [turnOnBtn setValue:[UIColor redColor] forKey:@"titleTextColor"];
                
                UIAlertAction*  CancelBtn = [UIAlertAction actionWithTitle:kLangCancel style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                    [self dismissViewControllerAnimated:YES completion:nil];
                }];
                
                [alert addAction:turnOnBtn];
                [alert addAction:CancelBtn];
                break;
            }
        }
    }
    
    if ( alert ) {
        [Tracker trackEvent:@"No_Location_Service" parameters:nil];
    }
    
    return alert;
}

@end
