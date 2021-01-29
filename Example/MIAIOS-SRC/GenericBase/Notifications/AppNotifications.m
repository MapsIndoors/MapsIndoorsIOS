//
//  AppNotifications.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 09/06/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "AppNotifications.h"


@implementation AppNotifications

+ (NSNotificationName) routeRequestNotificationName {
    return @"MI::routeRequest";
}

+ (NSString*) routeRequestOriginKey {
    return @"MI::routeRequest::origin";
}

+ (NSString*) routeRequestDestinationKey {
    return @"MI::routeRequest::destination";
}

+ (NSString*) routeRequestTravelModeKey {
    return @"MI::routeRequest::travelmode";
}

+ (NSString*) routeRequestAvoidsKey {
    return @"MI::routeRequest::avoids";
}


+ (NSDictionary*) userInfoDictForRouteRequestNotificationWithOrigin:(nullable MPLocation*)routeOrigin destination:(nullable MPLocation*)routeDestination travelMode:(nullable NSString*)travelMode avoids:(nullable NSArray<NSString*>*)avoids {

    NSMutableDictionary*    dict = [NSMutableDictionary dictionary];

    if ( routeOrigin ) {
        dict[ self.routeRequestOriginKey ] = routeOrigin;
    }
    if ( routeDestination ) {
        dict[ self.routeRequestDestinationKey ] = routeDestination;
    }
    if ( travelMode ) {
        dict[ self.routeRequestTravelModeKey ] = travelMode;
    }
    if ( avoids.count ) {
        dict[ self.routeRequestAvoidsKey ] = avoids;
    }

    return dict.count ? [dict copy] : nil;
}


+ (void) postRouteRequestNotificationWithOrigin:(nullable MPLocation*)routeOrigin destination:(nullable MPLocation*)routeDestination travelMode:(nullable NSString*)travelMode avoids:(nullable NSArray<NSString*>*)avoids {

    NSDictionary*  dict = [self userInfoDictForRouteRequestNotificationWithOrigin:routeOrigin destination:routeDestination travelMode:travelMode avoids:avoids];
    [[NSNotificationCenter defaultCenter] postNotificationName:self.routeRequestNotificationName object:nil userInfo:dict];
}


#pragma mark - Solution change notification
+ (NSNotificationName) solutionDataReadyNotificationName {
    return @"MI::solutionDataReady";
}

+ (NSString*) solutionObjectKey {
    return @"MI::solutionDataReady::solution";
}

+ (void) postSolutionDataReadyNotificationWithSolution:(nullable MPSolution*)solution {

    NSDictionary*   dict = solution ? @{ self.solutionObjectKey : solution } : @{};
    [[NSNotificationCenter defaultCenter] postNotificationName:self.solutionDataReadyNotificationName object:nil userInfo:dict];
}


#pragma mark - User roles change notification
+ (NSNotificationName) userRolesChangedNotificationName {
    return @"MI::userRolesChanged";
}

+ (void) postUserRolesChangedNotification {
    [[NSNotificationCenter defaultCenter] postNotificationName:self.userRolesChangedNotificationName object:nil userInfo:nil];
}


@end
