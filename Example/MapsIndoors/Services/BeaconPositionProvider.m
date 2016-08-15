//
//  BeaconPositionProvider.m
//  BellaCenter
//
//

#import "BeaconPositionProvider.h"
#import <MapsIndoorsSDK/MapsIndoorsSDK.h>
@import MaterialControls;
#include <sys/time.h>


@implementation BeaconPositionProvider {
    NSString* _UUID;
    NSString* _clientId;
    NSArray* _currentRangedBeacons;
    BOOL _firstGPSUpdate;
    MDToast* _toast;
    NSNumber* _manualFloor;
    NSDate* _lastManualFloorDate;
}

@synthesize providerType = _providerType;
@synthesize latestPositionResult = _latestPositionResult;
@synthesize delegate = _delegate;
@synthesize locationManager;
@synthesize heading;
@synthesize pos;
@synthesize probability;
@synthesize lastBeaconRecievedTime;

@synthesize floor = _floor;

-(id)initWithUUID:(NSString *)UUID {
    self = [super init];
    if (self) {		
        _UUID = UUID;
    }
    return self;
}

- (void)startPositioning:(NSString *)arg{
    _clientId = arg;
    if (![self isRunning]) {
        self.beaconProvider = [[MPBeaconProvider alloc] init];
        self.beaconProvider.delegate = self;
        _isRunning = YES;
        if (!self.locationManager)
            self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        locationManager.distanceFilter = 10;
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        locationManager.headingFilter = 10;
        [locationManager startUpdatingHeading];
        [locationManager startUpdatingLocation];
        self.beaconRegion = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:_UUID] identifier:@"Point"];
        [self.locationManager startRangingBeaconsInRegion:self.beaconRegion];
        heading = 0;
        probability = 0;
        lastBeaconRecievedTime = [self GetTime]-10;
        _firstGPSUpdate = YES;
    }
}

- (void)stopPositioning:(NSString *)arg {
    if ([self isRunning]) {
        _isRunning = NO;
        if (self.locationManager)
            [self.locationManager stopRangingBeaconsInRegion:self.beaconRegion];
    }
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if(beacons.count > 0) {
        _currentRangedBeacons = beacons;
        NSMutableArray* beaconIds = [[NSMutableArray alloc] init];
        for (CLBeacon* beacon in beacons) {
            [beaconIds addObject: [self formatBeaconIdFromBeacon:beacon]];
        }
        [self.beaconProvider getBeacons:beaconIds clientId:_clientId];
    }
}

- (NSString*) formatBeaconIdFromBeacon: (CLBeacon*) beacon {
    return [[NSString stringWithFormat:@"%@-%@-%@", [beacon.proximityUUID UUIDString], beacon.major, beacon.minor] lowercaseString];
}

- (void)setProviderType:(int)providerType {
    _providerType = providerType;
}

- (void)startPositioningAfter:(int)millis arg:(NSString *)arg {
    [self performSelector:@selector(startPositioning:) withObject:arg afterDelay:millis];
}

//Got a response from the server. We now have all the relevant (server) object to compare to.
- (void)onBeaconsReady:(NSArray *)beaconData {
    if ( beaconData.count == 0 )
        return;
    double minDist = DBL_MAX;
    MPBeacon* selectedBeacon;
    //Find the equivalent server beacon (MPBeacon) for all the found beacons (in _currentRangedBeacons)
    for (CLBeacon* clBeacon in _currentRangedBeacons) {
        MPBeacon *mpBeacon = [self GetServerBeacon:clBeacon mpBeacons:beaconData];
        if ( !mpBeacon || clBeacon.accuracy < 0 || clBeacon.rssi < -85) {
            continue;
        }
        else
        {
            //Maintain a cache of older RSSI values and take the average. This is needed as RSSI values fluctuates (quite) a bit
            if (!mpBeacon.RSSI){
                mpBeacon.RSSI = [[NSMutableArray alloc]init];
            }
            //Add the new value and remove the oldest if needed
            [mpBeacon.RSSI addObject: [[MPDouble alloc] init:clBeacon.rssi]];
            if ( mpBeacon.RSSI.count > 5 ) {
                [mpBeacon.RSSI removeObjectAtIndex:0];
            }
            //Finally get the new average RSSI for this beacon
            double avgRSSIval = 0;
            for (MPDouble *d in mpBeacon.RSSI) {
                avgRSSIval += d.doubleValue;
            }
            avgRSSIval /= mpBeacon.RSSI.count;
            double distance = [PositionCalculator convertRSSItoMeter:avgRSSIval A:[mpBeacon.maxTxPower doubleValue]];
            if ([[mpBeacon.beaconId lowercaseString] isEqualToString:[self formatBeaconIdFromBeacon:clBeacon]]) {
                if ( distance < minDist && mpBeacon.RSSI.count >= 5)  {
                    minDist = distance;
                    selectedBeacon = mpBeacon;
                }
            }
        }
    }
    //Set location data to the selected beacon (Shortest distance to the device)
    if ( selectedBeacon ) {
        [selectedBeacon.geometry setZValue:[selectedBeacon.floor doubleValue]];
        pos = selectedBeacon.geometry;
        probability = minDist;
        
        //Reset the timestamp for the latest beacon to ensure we keep seing beacon positions for a while - even if we dont get a beacon update for a short while.
        self.lastBeaconRecievedTime = [self GetTime];
        [self setNewLocation];
    }
}

- (void)setNewLocation
{
    if (self.delegate && pos) {
        if (_manualFloor && [_lastManualFloorDate timeIntervalSinceNow] > -30) {
            [pos setZValue:[_manualFloor doubleValue]];
        }
        
        self.latestPositionResult = [[MPPositionResult alloc] init];
        self.latestPositionResult.geometry = pos;
        [self.latestPositionResult setProbability:probability];
        [self.latestPositionResult setHeadingDegrees:heading];
        self.latestPositionResult.provider = self;
        [self.delegate onPositionUpdate:self.latestPositionResult];
    }
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading{
    heading = newHeading.trueHeading;
    [self setNewLocation];
}

// Location Manager Delegate Method for GPS:
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    
    if (_firstGPSUpdate) {
        // Set accuracy to BEST after first GPS fix
        [locationManager stopUpdatingLocation];
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        [locationManager startUpdatingLocation];
        _firstGPSUpdate = NO;
    }
    
    //Using GPS locations if it's been a while (5sec) since last beacon update:
    double timeSinceBeaconUpdate = [self GetTime] - lastBeaconRecievedTime;
    if (  timeSinceBeaconUpdate > 5 )
    {
        //We have a GPS position - and no beacon positions for a while.
        //Showing GPS position while we wait to hear from beacons again.
        double latestFloor = 0;
        if (_latestPositionResult) {
            latestFloor = [[_latestPositionResult getFloor] doubleValue];
        }
        pos = [[MPPoint alloc] initWithLat:locationManager.location.coordinate.latitude lon:locationManager.location.coordinate.longitude zValue:latestFloor];
        probability = locationManager.location.horizontalAccuracy;
        [self setNewLocation];
    }
}


-(MPBeacon*)GetServerBeacon:(CLBeacon*) clBeacon mpBeacons:(NSArray*)mpBeacons{
    //First find the beaconId of the clBeacon
    NSString *beaconId = [self formatBeaconIdFromBeacon:clBeacon];
    //Now find the corresponding mpBeacon and return it if possible
    for (MPBeacon* mpBeacon in mpBeacons) {
        if ([[beaconId lowercaseString] isEqualToString:[mpBeacon.beaconId lowercaseString]] )
        {
            return mpBeacon;
        }
    }
    return nil;

}

- (void)setFloor:(NSNumber *)floor {
    _manualFloor = floor;
    _lastManualFloorDate = [NSDate date];
    [self setNewLocation];
}

- (double)ToRad:(double) deg
{
    return deg * ( M_PI / 180);
}

//Return unix time in seconds
- (double)GetTime
{
    struct timeval time;
    gettimeofday(&time, NULL);
    return (double)((time.tv_sec * 1000) + (time.tv_usec / 1000))/1000.0f;
}


@end
