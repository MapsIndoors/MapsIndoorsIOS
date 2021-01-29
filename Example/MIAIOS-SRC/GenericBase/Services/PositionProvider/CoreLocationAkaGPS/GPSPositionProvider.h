//
//  GPSPositionProvider.h
//  MIAIOS
//
//  Created by Daniel Nielsen on 27/03/14.
//  Copyright (c) 2014-2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapsIndoors/MapsIndoors.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "AppPositionProvider.h"


@interface GPSPositionProvider : NSObject <MPPositionProvider, CLLocationManagerDelegate, AppPositionProvider>

@property (nonatomic) BOOL                              preferAlwaysLocationPermission;
@property (nonatomic, readonly) BOOL                    locationServicesEnabled;
@property (nonatomic, readonly) CLAuthorizationStatus   authorizationStatus;
@property (nonatomic, readonly) BOOL                    locationServicesActive;     // enabled AND authorized
@property (nonatomic, readonly) NSUInteger              permissionsChangeCount;

- (void) requestLocationPermissions;
- (void) updateLocationPermissionStatus;

- (void) notifyLatestPositionResult;

@end
