//
//  MPNotificationsHelper.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 09/03/16.
//  Copyright © 2016 Daniel Nielsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "MPMessage.h"

@interface MPNotificationsHelper : NSObject

+ (void)setupNotificationsForApp:(UIApplication *)application withLocationManager:(CLLocationManager*)locationManager;
+ (void) fetchMessagesForSolution: (NSString*)solutionId completionHandler: (void (^)(UIBackgroundFetchResult))completionHandler messageHandler: (void (^)(MPMessage* message))messageHandler;
+ (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region;
+ (void)monitorRegionForMessage:(MPMessage*)message withLocationManager:(CLLocationManager*)locationManager;

@end
