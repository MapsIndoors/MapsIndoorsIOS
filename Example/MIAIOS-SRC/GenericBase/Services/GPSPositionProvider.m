//
//  GPSPositionProvider.m
//  MIAIOS
//
//  Created by Daniel Nielsen on 27/03/14.
//  Copyright (c) 2014-2018 MapsPeople A/S. All rights reserved.
//

#import "GPSPositionProvider.h"
#import <MapsIndoors/MapsIndoors.h>
#import "Global.h"

@interface GPSPositionProvider ()

@property (nonatomic, strong)    CLLocationManager*     locationManager;
@property (nonatomic, readwrite) BOOL                   locationServicesEnabled;
@property (nonatomic, readwrite) CLAuthorizationStatus  authorizationStatus;
@property (nonatomic, readwrite) BOOL                   locationServicesActive;     // enabled AND authorized
@property (nonatomic, readwrite) NSUInteger             permissionsChangeCount;

@end


@implementation GPSPositionProvider {
    BOOL _isRunning;
}

@synthesize providerType = _providerType;
@synthesize latestPositionResult = _latestPositionResult;
@synthesize delegate = _delegate;


- (instancetype) init {
    
    self = [super init];
    if ( self ) {
        _locationServicesEnabled = [CLLocationManager locationServicesEnabled];
        _locationServicesActive = NO;       // Pending status from CLLocationManager
        _authorizationStatus = -1;          // Invalid CLAuthorizationStatus value
        _permissionsChangeCount = 0;
    }
    return self;
}

- (void) startPositioning:(NSString *)arg{
    if ( ![self isRunning] ) {
        _isRunning = YES;
        if (!self.locationManager) {
            self.locationManager = [[CLLocationManager alloc] init];
        }
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 7;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        self.latestPositionResult = [MPPositionResult new];
        
        [self requestLocationPermissions];
        
        [self.locationManager startUpdatingLocation];
        [self.locationManager startUpdatingHeading];
    }
}

- (void) stopPositioning:(NSString *)arg {
    if ([self isRunning]) {
        _isRunning = NO;
        if (self.locationManager) {
            [self.locationManager stopUpdatingLocation];
        }
    }
}

- (BOOL) isRunning {
    return _isRunning;
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (locations.count > 0) {
        if ([self isRunning]) {
            CLLocation* loc = [locations lastObject];
            if (loc != nil) {
                self.latestPositionResult.geometry = [[MPPoint alloc] initWithLat:loc.coordinate.latitude lon:loc.coordinate.longitude];
                if ( (loc.course >= 0) && (loc.course <= 360) ) {
                    [self.latestPositionResult setHeadingDegrees:loc.course];
                }
                if (loc.floor) {
                    [self.latestPositionResult.geometry setZValue:loc.floor.level];
                }
                
                [self.latestPositionResult setProbability:loc.horizontalAccuracy];
                self.latestPositionResult.provider = self;

                // Mock position:
                // self.latestPositionResult.geometry = [[MPPoint alloc] initWithLat:32.787428 lon:-96.797634 zValue:0];

                [self notifyLatestPositionResult];
            }
        }
    }
}

- (void) notifyLatestPositionResult {
    
    if ( [self.delegate respondsToSelector:@selector(onPositionUpdate:)] ) {
        [self.delegate onPositionUpdate:self.latestPositionResult];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PositionUpdate" object: self.latestPositionResult];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {

    if ( self.latestPositionResult.geometry ) {
        if ( (newHeading.trueHeading >= 0) && (newHeading.trueHeading <= 360) ) {
            [self.latestPositionResult setHeadingDegrees:newHeading.trueHeading];
            
            if ( [self.delegate respondsToSelector:@selector(onPositionUpdate:)] ) {
                [self.delegate onPositionUpdate:self.latestPositionResult];
            }
        }
    }
}

- (void) locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    [self updateLocationPermissionStatus];
}

- (void) setProviderType:(MPPositionProviderType)providerType {
    _providerType = providerType;
}

- (void) locationManger:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog( @"locationManger:didFailWithError: %@", error );
    if (self.delegate) {
        [self.delegate onPositionFailed:self];
    }
}

- (void) startPositioningAfter:(int)millis arg:(NSString *)arg {
    [self performSelector:@selector(startPositioning:) withObject:arg afterDelay:millis];
}

- (void) requestLocationPermissions {
    
    if ( self.preferAlwaysLocationPermission ) {
        [self.locationManager requestAlwaysAuthorization];
    } else {
        [self.locationManager requestWhenInUseAuthorization];
    }
}

- (void) updateLocationPermissionStatus {
    
    BOOL    bDidChange = NO;
    
    BOOL bEnabled = [CLLocationManager locationServicesEnabled];
    if ( self.locationServicesEnabled !=  bEnabled ) {
        self.locationServicesEnabled = bEnabled;
        bDidChange = YES;
        NSLog( @"%s: locationServicesEnabled => %@", __PRETTY_FUNCTION__, @(self.locationServicesEnabled) );
    }
    
    CLAuthorizationStatus   status = [CLLocationManager authorizationStatus];
    if ( self.authorizationStatus != status ) {
        NSLog( @"%s: authorizationStatus %@ => %@", __PRETTY_FUNCTION__, @(self.authorizationStatus), @(status) );
        self.authorizationStatus = status;
        bDidChange = YES;
        
        BOOL isActiveNow = (status == kCLAuthorizationStatusAuthorizedAlways) || (status == kCLAuthorizationStatusAuthorizedWhenInUse);
        if ( isActiveNow != self.locationServicesActive ) {
            self.locationServicesActive = isActiveNow;
            
            if ( isActiveNow ) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLocationServicesActivated object:self];

            } else {
            
                self.latestPositionResult = nil;
                [self notifyLatestPositionResult];
            }
        }
    }
    
    if ( bDidChange ) {
        ++self.permissionsChangeCount;
    }
}

@end
