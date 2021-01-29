//
//  AppNotifications.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 09/06/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MPLocation;
@class MPSolution;


NS_ASSUME_NONNULL_BEGIN

@interface AppNotifications : NSObject

#pragma mark - Route request notification
@property (nonatomic, strong, readonly, class) NSNotificationName       routeRequestNotificationName;
@property (nonatomic, strong, readonly, class) NSString*                routeRequestOriginKey;              // .userInfo key
@property (nonatomic, strong, readonly, class) NSString*                routeRequestDestinationKey;         // .userInfo key
@property (nonatomic, strong, readonly, class) NSString*                routeRequestTravelModeKey;          // .userInfo key
@property (nonatomic, strong, readonly, class) NSString*                routeRequestAvoidsKey;              // .userInfo key

/// Create a userInfo dictionary for route request notifications.
/// @param routeOrigin routeOrigin
/// @param routeDestination routeDestination
/// @param travelMode travelMode
/// @param avoids avoids
/// @return dictionary or nil if all inputs are nil.
+ (NSDictionary*) userInfoDictForRouteRequestNotificationWithOrigin:(nullable MPLocation*)routeOrigin destination:(nullable MPLocation*)routeDestination travelMode:(nullable NSString*)travelMode avoids:(nullable NSArray<NSString*>*)avoids;

/// Post a route request with the given parameters.
/// @param routeOrigin routeOrigin
/// @param routeDestination routeDestination
/// @param travelMode travelMode
/// @param avoids avoids
+ (void) postRouteRequestNotificationWithOrigin:(nullable MPLocation*)routeOrigin destination:(nullable MPLocation*)routeDestination travelMode:(nullable NSString*)travelMode avoids:(nullable NSArray<NSString*>*)avoids;


#pragma mark - Solution change notification
@property (nonatomic, strong, readonly, class) NSNotificationName       solutionDataReadyNotificationName;
@property (nonatomic, strong, readonly, class) NSString*                solutionObjectKey;                  // .userInfo key => MPSolution

+ (void) postSolutionDataReadyNotificationWithSolution:(nullable MPSolution*)solution;


#pragma mark - User roles change notification
@property (nonatomic, strong, readonly, class) NSNotificationName       userRolesChangedNotificationName;

+ (void) postUserRolesChangedNotification;


@end

NS_ASSUME_NONNULL_END
