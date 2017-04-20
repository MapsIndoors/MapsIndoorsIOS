//
//  KUGPSPositionProvider.m
//  KUDigitalMap
//
//  Created by Daniel Nielsen on 27/03/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import "GPSPositionProvider.h"
#import <MapsIndoors/MapsIndoors.h>

@implementation GPSPositionProvider {
    BOOL _isRunning;
}

@synthesize providerType = _providerType;
@synthesize latestPositionResult = _latestPositionResult;
@synthesize delegate = _delegate;


- (void)startPositioning:(NSString *)arg{
    if (![self isRunning]) {
        _isRunning = YES;
        if (!locationManager)
            locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.distanceFilter = 7;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
        if ([locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [locationManager requestWhenInUseAuthorization];
        }
        
        [locationManager startUpdatingLocation];
        [locationManager startUpdatingHeading];
    }
}

- (void)stopPositioning:(NSString *)arg {
    if ([self isRunning]) {
        _isRunning = NO;
        if (locationManager)
            [locationManager stopUpdatingLocation];
    }
}

- (BOOL)isRunning {
    return _isRunning;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    if (locations.count > 0) {
        if ([self isRunning]) {
            CLLocation* loc = [locations lastObject];
            
            self.latestPositionResult = [[MPPositionResult alloc] init];
            self.latestPositionResult.geometry = [[MPPoint alloc] initWithLat:loc.coordinate.latitude lon:loc.coordinate.longitude];
            if ( (loc.course >= 0) && (loc.course <= 360) ) {
                [self.latestPositionResult setHeadingDegrees:loc.course];
            }
            [self.latestPositionResult setProbability:loc.horizontalAccuracy];
            self.latestPositionResult.provider = self;
            
            if (loc && self.delegate) {
                [self.delegate onPositionUpdate:self.latestPositionResult];
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"PositionUpdate" object: self.latestPositionResult];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    
    if ( self.latestPositionResult ) {
        if ( (newHeading.trueHeading >= 0) && (newHeading.trueHeading <= 360) ) {
            [self.latestPositionResult setHeadingDegrees:newHeading.trueHeading];
            
            if ( [self.delegate respondsToSelector:@selector(onPositionUpdate:)] ) {
                [self.delegate onPositionUpdate:self.latestPositionResult];
            }
        }
    }
}

- (void)setProviderType:(int)providerType {
    _providerType = providerType;
}

-(void)locationManger:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
    if (self.delegate) {
        [self.delegate onPositionFailed:self];
    }
}

- (void)startPositioningAfter:(int)millis arg:(NSString *)arg {
    [self performSelector:@selector(startPositioning:) withObject:arg afterDelay:millis];
}

@end
