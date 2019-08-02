//
//  AppDelegate.h
//  MIAIOS
//
//  Created by Daniel Nielsen on 10/08/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapsIndoors/MapsIndoors.h>
#import <UserNotifications/UserNotifications.h>



typedef BOOL (^OpenUrlHookBlock)( UIApplication* app, NSURL* url, NSDictionary<NSString *,id>* options );


@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UIWindow*                 window;
@property (strong, nonatomic) UINavigationController*   navigationController;
@property (strong, nonatomic) NSString*                 locationIdToOpen;
@property (nonatomic, copy) OpenUrlHookBlock            openUrlHook;

@end

