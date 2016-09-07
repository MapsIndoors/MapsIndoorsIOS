//
//  MPNotificationsHelper.m
//  MapsIndoors
//
//  Created by Daniel Nielsen on 09/03/16.
//  Copyright © 2016 Daniel Nielsen. All rights reserved.
//

#import "NotificationsHelper.h"

@implementation NotificationsHelper

static NSMutableArray* _messages;

+ (void)setupNotificationsForApp:(UIApplication *)application withLocationManager:(CLLocationManager *)locationManager {
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings* notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    
    if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [locationManager requestAlwaysAuthorization];
    }
}

+ (void) fetchMessagesForSolution: (NSString*)solutionId completionHandler: (void (^)(UIBackgroundFetchResult))completionHandler messageHandler: (void (^)(MPMessage* message))messageHandler {
    
    MPMessagesProvider* messageProvider = [[MPMessagesProvider alloc] init];
    [messageProvider getMessagesAsync:solutionId language:[[NSLocale preferredLanguages] objectAtIndex:0] completionHandler:^(NSArray<MPMessage>* messages, NSError *error) {
        if (error) {
            if (completionHandler) completionHandler(UIBackgroundFetchResultFailed);
        } else {
            if (_messages == nil) {
                _messages = [[NSMutableArray alloc] init];
            }
            
            for (MPMessage *message in messages) {
                NSArray* res = [_messages filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"messageId == %@", message.messageId]];
                if (res.count == 0) {
                    [_messages addObject:message];
                } else {
                    MPMessage* messageToUpdate = [res firstObject];
                    NSDate* delivered = messageToUpdate.deliveredDate;
                    if ([message.content isEqualToString:messageToUpdate.content]) {
                        message.deliveredDate = delivered;
                    } else {
                        message.deliveredDate = nil;
                    }
                    messageToUpdate = message;
                }
                if (messageHandler) messageHandler(message);
                
            }
            if (completionHandler) completionHandler(UIBackgroundFetchResultNewData);
        }
    }];
    
}

+ (void)monitorRegionForMessage:(MPMessage*)message withLocationManager:(CLLocationManager*)locationManager {
    if (message.beaconId && message.deliveredDate == nil) {
        NSArray* uuidMajorMinor = [message.beaconId componentsSeparatedByString:@"-"];
        if (uuidMajorMinor.count > 3) {
            NSIndexSet* set = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, uuidMajorMinor.count - 2)];
            NSString* uuidString = [[uuidMajorMinor objectsAtIndexes:set] componentsJoinedByString:@"-"];
            NSUUID* uuid = [[NSUUID alloc] initWithUUIDString: uuidString];
            int major = [[uuidMajorMinor objectAtIndex:uuidMajorMinor.count - 2] intValue];
            int minor = [[uuidMajorMinor objectAtIndex:uuidMajorMinor.count - 1] intValue];
            CLBeaconRegion* region = [[CLBeaconRegion alloc] initWithProximityUUID: uuid major: major minor:minor identifier:message.beaconId];
            [locationManager startMonitoringForRegion:region];
        }
        //fetch image ressource
        if (message.imagePath != nil && [message.imagePath containsString:@"https://"]) {
            [MPImageProvider getImageFromUrlStringAsync:message.imagePath completionHandler:^(UIImage *image, NSError *error) {
                if (error == nil) {
                    message.image = image;
                }
            }];
        }
    }
}

+ (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    for (MPMessage *message in _messages) {
        if (message.beaconId) {
            if ([message.beaconId isEqualToString:region.identifier]) {
                if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
                    UILocalNotification* localNotification = [[UILocalNotification alloc] init];
                    localNotification.alertBody = message.content;
                    localNotification.alertTitle = message.title;
                    if (message.locationId) {
                        localNotification.userInfo = @{@"locationId": message.locationId};
                    }
                    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                    message.deliveredDate = [NSDate date];
                    [manager stopMonitoringForRegion:region];
                }
            }
        }
    }
}

@end
