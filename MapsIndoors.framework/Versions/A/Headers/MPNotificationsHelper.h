//
//  MPNotificationsHelper.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 09/03/16.
//  Copyright  Daniel Nielsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "MPMessage.h"

@interface MPNotificationsHelper : NSObject

+ (void) setupNotificationsForApp:(nonnull UIApplication *)application withLocationManager:(nonnull CLLocationManager*)locationManager;
+ (void) fetchMessagesForSolution: (nonnull NSString*)solutionId completionHandler: (nullable void (^)(UIBackgroundFetchResult))completionHandler messageHandler: (nullable void (^)(MPMessage* _Nonnull message))messageHandler;
+ (void) locationManager:(nonnull CLLocationManager *)manager didEnterRegion:(nonnull CLRegion *)region;
+ (void) monitorRegionForMessage:(nonnull MPMessage*)message withLocationManager:(nonnull CLLocationManager*)locationManager;

@end
