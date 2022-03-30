//
//  MPCiscoDnaPositionProvider2.m
//
//  Created by Michael Bech Hansen on 11/08/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "MPCiscoDnaPositionProvider2.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>

#include <ifaddrs.h>
#include <arpa/inet.h>


#if DEBUG && 1
    #define DEBUGLOG(fMT,...)  NSLog( @"[D] MPCiscoDnaPositionProvider2.m(%d): "fMT,  __LINE__, __VA_ARGS__ )
#else
    #define DEBUGLOG(fMt,...)  /* Nada! */
#endif


#if DEBUG && 0
    #define FAKE_TILL_WE_MAKE_IT        1
#endif


@interface MPCiscoDnaPositionProvider2 () <MPSubscriptionClientDelegate>

@property (nonatomic, strong) NSURLSession*                 urlSession;
@property (nonatomic, strong) NSURLSessionTask*             deviceIdTask;
@property (nonatomic, strong) NSURLSessionTask*             deviceLocationTask;
@property (nonatomic, strong) NSURLSessionTask*             wanIpRefreshTask;

@property (nonatomic, readwrite) BOOL                       isRunning;
@property (nonatomic, readwrite) BOOL                       isNetworkReachable;

@property (nonatomic, strong) NSString*                     lanIpAddress;
@property (nonatomic, strong) NSString*                     wanIpAddress;
@property (nonatomic, strong) NSString*                     ciscoDeviceId;
@property (nonatomic, strong) NSDate*                       lastCiscoPositionTimestamp;

@property (nonatomic, strong) CLLocation*                   lastGpsPosition;
@property (nonatomic, strong) NSDate*                       lastGpsPositionTimestamp;

@property (nonatomic, strong) CLHeading*                    lastHeading;

@property (nonatomic, strong) NSISO8601DateFormatter*       dateFormatter;

@property (nonatomic, strong) NSString*                     gpsDebugInfo;
@property (nonatomic, strong) NSString*                     ciscoDnaDebugInfo;
@property (nonatomic, strong) NSNumber*                     ciscoUpdateAge;
@property (nonatomic, strong) NSString*                     posSrcDebug;

@property (nonatomic, strong) MPMQTTSubscriptionClient*     mqttClient;

@end


@implementation MPCiscoDnaPositionProvider2

- (instancetype) init {

    self = [super init];
    if (self) {

        self.mqttClient = [MPMQTTSubscriptionClient new];
        
        _refreshInterval = 1;
        _ciscoPositionMaxAge = 120; 
        _posSrcDebug = @"GPS";
        
        self.isNetworkReachable = YES;
        

    }

    return self;
}


- (void) setWanIpAddress:(NSString*)wanIpAddress {

    if ( (_wanIpAddress != wanIpAddress) || ([_wanIpAddress isEqualToString:wanIpAddress] == NO) ) {

        DEBUGLOG( @"LAN IP: %@ => %@", _wanIpAddress, wanIpAddress );
        _wanIpAddress = wanIpAddress;

        [self updateDeviceId];
    }
}


- (void) setLanIpAddress:(NSString*)lanIpAddress {

    if ( (_lanIpAddress != lanIpAddress) || ([_lanIpAddress isEqualToString:lanIpAddress] == NO) ) {

        DEBUGLOG( @"LAN IP: %@ => %@", _lanIpAddress, lanIpAddress );
        _lanIpAddress = lanIpAddress;

        [self updateWanIpAddress];
//        [self resendLastGpsPosition];
    }
}

- (void) setCiscoDeviceId:(NSString *)ciscoDeviceId {
    
    if (_ciscoDeviceId != ciscoDeviceId) {
    
        _ciscoDeviceId = ciscoDeviceId;
        
        if (_ciscoDeviceId) {
        
            [self updateDeviceLocationFromCisco];
            
            [self connectToMQTT];
            
        } else {
            
            [self performSelector:@selector(refreshDeviceInfo) withObject:nil afterDelay:2];
            
        }
        
    }
    
}

- (void)connectToMQTT {
    self.mqttClient.delegate = self;
    if (self.mqttClient.state != MPSubscriptionStateConnected) {
        [self.mqttClient connect:YES];
    } else {
        [self subscribeToCiscoDNAPositioning];
    }
}


- (void) unsubscribeCiscoDNAPositioning {
    
    if (self.tenantId && self.ciscoDeviceId) {
    
        MPWirelessPositionTopic* topic = [[MPWirelessPositionTopic alloc] initWithTenantId:self.tenantId deviceId:self.ciscoDeviceId];
    
        [self.mqttClient unsubscribe:topic];
        
    }
    
}


- (void) subscribeToCiscoDNAPositioning {
    
    MPWirelessPositionTopic* topic = [[MPWirelessPositionTopic alloc] initWithTenantId:self.tenantId deviceId:self.ciscoDeviceId];
    
    [self.mqttClient subscribe:topic];
    
}

#pragma mark - Date/string helpers

- (NSISO8601DateFormatter*) dateFormatter {

    if ( _dateFormatter == nil ) {
        _dateFormatter = [NSISO8601DateFormatter new];
    }

    return _dateFormatter;
}


#pragma mark - URL helpers

- (NSURLSession*) urlSession {

    if ( _urlSession == nil ) {
        NSURLSessionConfiguration* urlSessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        [urlSessionConfig setRequestCachePolicy:NSURLRequestUseProtocolCachePolicy];
        [urlSessionConfig setTimeoutIntervalForRequest:10];

        _urlSession = [NSURLSession sessionWithConfiguration:urlSessionConfig delegate:nil delegateQueue:nil];
    }

    return _urlSession;
}

- (NSString*) urlForResolvingDeviceId {

    return [NSString stringWithFormat:@"https://ciscodna.mapsindoors.com/%@/api/ciscodna/devicelookup?clientIP=%@&wanIp=%@", self.tenantId, self.lanIpAddress, self.wanIpAddress];
}

- (NSString*) urlForResolvingDeviceLocation {

    return [NSString stringWithFormat:@"https://ciscodna.mapsindoors.com/%@/api/ciscodna/%@", self.tenantId, self.ciscoDeviceId];
}

- (NSString*) urlForResolvingDeviceWanIp {

    return @"https://ipinfo.io/ip";
}


#pragma mark - IP address helpers

- (NSString*) getLanIPAddress {

    DEBUGLOG( @"Refreshing LAN IP: current=%@", self.lanIpAddress );

    NSString*       address;
    struct ifaddrs* interfaces = NULL;
    struct ifaddrs* temp_addr = NULL;
    int             success = getifaddrs( &interfaces );      // retrieve the current interfaces - returns 0 on success

    if ( success == 0 ) {
        // Loop through linked list of interfaces, finding 'en0'  interface, which is the wifi connection on the iPhone
        temp_addr = interfaces;
        while ( temp_addr != NULL ) {
            if ( temp_addr->ifa_addr->sa_family == AF_INET ) {
                if ( [[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"] ) {
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }

            temp_addr = temp_addr->ifa_next;
        }
    }

    freeifaddrs( interfaces );

#if FAKE_TILL_WE_MAKE_IT
    return @"10.0.0.69";
#endif

    return address;
}


- (void) updateWanIpAddress {

    DEBUGLOG( @"Refreshing WAN IP: current=%@", self.wanIpAddress );

    [self.wanIpRefreshTask cancel];

    NSMutableURLRequest*    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlForResolvingDeviceWanIp]];

    __weak __typeof(self) weakSelf = self;
    NSURLSessionTask*   task = [self.urlSession dataTaskWithRequest:request completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {

        NSString*       wanIp;

        if ( !error ) {

            NSString*               responseObject = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSArray<NSString*>*     lines = [responseObject componentsSeparatedByString:@"\n"];
            wanIp = lines.firstObject;
        }

        dispatch_async(dispatch_get_main_queue(), ^{

            if ( !error ) {
                weakSelf.wanIpAddress = wanIp;
            }

            DEBUGLOG( @"%@", weakSelf.debugDescription );
        });
    }];

    self.wanIpRefreshTask = task;
    [task resume];
}


- (void) updateDeviceId {

    DEBUGLOG( @"Refreshing device ID: current=%@", self.ciscoDeviceId );

    [self.deviceIdTask cancel];

    NSMutableURLRequest*    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlForResolvingDeviceId]];

    __weak __typeof(self) weakSelf = self;
    NSURLSessionTask*   task = [self.urlSession dataTaskWithRequest:request completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {

        NSString*       ciscoDeviceId;

        if ( !error ) {

            NSError*    error;
            id          responseObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

            if ( [responseObject isKindOfClass:[NSDictionary class]] ) {
                NSDictionary*   responseDict = responseObject;
                ciscoDeviceId = responseDict[@"deviceId"];
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{

            if ( !error ) {
                weakSelf.ciscoDeviceId = ciscoDeviceId;
            }

            DEBUGLOG( @"%@", weakSelf.debugDescription );
        });
    }];

    self.deviceIdTask = task;
    [task resume];
}

- (void) updateDeviceLocationFromCisco {

    [self.deviceLocationTask cancel];

    NSMutableURLRequest*    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlForResolvingDeviceLocation]];

    __weak __typeof(self) weakSelf = self;
    NSURLSessionTask*   task = [self.urlSession dataTaskWithRequest:request completionHandler:^(NSData *_Nullable data, NSURLResponse *_Nullable response, NSError *_Nullable error) {

        if ( !error ) {

            MPPositionResult* result = [[MPPositionResult alloc] initWithWirelessPositionData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                [self evaluateDeviceLocationFromCisco:result];
                
            });
            
        }
        
    }];

    self.deviceLocationTask = task;
    [task resume];
}


- (void) evaluateDeviceLocationFromCisco:(MPPositionResult*) positionResult {
    
    self.ciscoUpdateAge = positionResult.properties[@"age"];
    self.lastCiscoPositionTimestamp = [NSDate.date dateByAddingTimeInterval:-self.ciscoUpdateAge.doubleValue];
    
    DEBUGLOG( @"Got device location: latitude=%@, longitude=%@, floor=%@", @(positionResult.geometry.lat), @(positionResult.geometry.lng), positionResult.getFloor );

    if ( [self shouldUseCiscoPosition] ) {
        [self notifyCiscoDnaPosition:positionResult];
    }
    
    
}


#pragma mark - Cisco positioning refresh

- (void) refreshDeviceInfo {

    self.lanIpAddress = [self getLanIPAddress];

    DEBUGLOG( @"%@", self.debugDescription );

    if ( self.wanIpAddress == nil ) {
        [self updateWanIpAddress];
    }

    if ( self.lanIpAddress && self.wanIpAddress ) {
        [self updateDeviceId];
    }
}

- (void) clearDeviceInfo {
    self.lanIpAddress = nil;
    self.wanIpAddress = nil;
}

#pragma mark - Debug helpers

- (NSString*) debugDescription {

    NSMutableArray<NSString*>*  details = [NSMutableArray array];

    [details addObject: [NSString stringWithFormat:@"<MPCiscoDnaPositionProvider %p>", self] ];

    #define _X(nAME,pROP)        [details addObject: [NSString stringWithFormat:@".%@ = %@", nAME, self.pROP]];
    #define _Y(nAME,pROP)        [details addObject: [NSString stringWithFormat:@".%@ = %@", nAME, @(self.pROP)]];

    _X(@"lanIP",lanIpAddress);
    _X(@"wanIp",wanIpAddress);
    if ( self.ciscoUpdateAge ) {
        _X(@"age(sec)", self.ciscoUpdateAge);
    }
    _X(@"reqTime",lastCiscoPositionTimestamp);

    return [details componentsJoinedByString:@"\n "];
}


#pragma mark MPPositionProvider methods

- (void) startPositioning:(nullable NSString *)arg {

    [super startPositioning:arg];
    if ( !self.isRunning ) {

        [self refreshDeviceInfo];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];

        self.isRunning = YES;
    }
}


- (void) startPositioningAfter:(int)millis arg:(nullable NSString *)arg {

    [self performSelector:@selector(startPositioning:) withObject:arg afterDelay:millis];
}


- (void) stopPositioning:(nullable NSString *)arg {

    [super stopPositioning:arg];
    if ( self.isRunning ) {

        [[NSNotificationCenter defaultCenter] removeObserver:self name:AFNetworkingReachabilityDidChangeNotification object:nil];
        
        [self.mqttClient disconnect];
        
        self.isRunning = NO;
    }
}


- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {

    if ( locations.count ) {

        DEBUGLOG( @"locationManager:didUpdateLocations: lat %.9f, lng %.9f", locations.firstObject.coordinate.latitude, locations.firstObject.coordinate.longitude );

        self.gpsDebugInfo = [NSString stringWithFormat: @"GPS: %.6f,%.6f, a=%@", locations.firstObject.coordinate.latitude, locations.firstObject.coordinate.longitude, @((int)locations.firstObject.horizontalAccuracy) ];
        self.lastGpsPosition = locations.firstObject;
        self.lastGpsPositionTimestamp = [NSDate date];

        if ( [self shouldUseCiscoPosition] == NO ) {
            self.posSrcDebug = @"GPS";
            [super locationManager:manager didUpdateLocations:locations];
        }
    }
}


- (void) locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    if (newHeading) {
        if ( (newHeading.trueHeading >= 0) && (newHeading.trueHeading <= 360) ) {
            self.lastHeading = newHeading;
            if ( ([self shouldUseCiscoPosition] == NO) ) {
                [super locationManager:manager didUpdateHeading:newHeading];
            } else {
                if (self.latestPositionResult) {
                    [self notifyCiscoDnaPosition:self.latestPositionResult];
                }
            }
        }
    }
}


- (void) resendLastGpsPosition {

    if ( self.lastGpsPosition ) {
        self.posSrcDebug = @"GPS";
        [self locationManager:[self valueForKey:@"locationManager"] didUpdateLocations:@[ self.lastGpsPosition ]];
    }
}


- (void) notifyCiscoDnaPosition:(MPPositionResult*)positionResult {

    if ( self.isRunning ) {

        self.latestPositionResult = positionResult;
        self.latestPositionResult.headingAvailable = self.lastHeading != nil;
        [self.latestPositionResult setHeadingDegrees:self.lastHeading.trueHeading];
        self.latestPositionResult.provider = self;

        self.posSrcDebug = @"DNA";

        [self notifyLatestPositionResult];
    }
}

- (BOOL) shouldUseCiscoPosition {

    NSTimeInterval      maxCiscoPositionAge = self.ciscoPositionMaxAge;
    BOOL                haveCiscoTimeStamp = self.lastCiscoPositionTimestamp != nil;
    NSTimeInterval      currentAge = fabs([NSDate.date timeIntervalSinceDate:self.lastCiscoPositionTimestamp]);
    BOOL                ciscoPositionNewerThanMaxAge = currentAge < maxCiscoPositionAge;

    DEBUGLOG( @"haveCiscoTimeStamp=%@, ciscoPositionNewerThanMaxAge=%@, maxAge=%@, age=%@", @(haveCiscoTimeStamp), @(ciscoPositionNewerThanMaxAge), @(maxCiscoPositionAge), @(currentAge) );

    return haveCiscoTimeStamp && ciscoPositionNewerThanMaxAge;
}


#pragma mark - AppPositionProvider

- (NSString*) name {
    return @"CiscoDNA+CoreLocation";
}

- (NSString*) version {
    return nil;
}

- (NSString*) debugInfo {

    return [NSString stringWithFormat:@" Using: %@ \n\n %@ \n %@ ", self.posSrcDebug, self.debugDescription, super.debugInfo];
}

- (nonnull id<MPPositionProvider>)initWithConfigDict:(nonnull NSDictionary *)dict {

    NSString*   tenantId = dict[@"ciscoDnaSpaceTenantId"];

    if ( tenantId == nil ) {
        self = nil;
    } else {
        self = [self init];
        self.tenantId = tenantId;
    }

    return [self init];
}

+ (nonnull id<MPPositionProvider>)newWithConfigDict:(nonnull NSDictionary *)dict {
    return [[self alloc] initWithConfigDict:dict];
}

- (BOOL)canDeliverPosition {
    return [self shouldUseCiscoPosition] && [self.lastCiscoPositionTimestamp timeIntervalSinceNow] > -10;
}

#pragma mark MPMQTTSubscriptionClient


- (void)didReceiveMessage:(nonnull NSData *)message onTopic:(nonnull NSString *)topicString {
    
    MPPositionResult* result = [[MPPositionResult alloc] initWithWirelessPositionData:message];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        [self evaluateDeviceLocationFromCisco:result];
        
    });
    
}

- (void)didSubscribe:(nonnull id<MPSubscriptionTopic>)topic {
    DEBUGLOG(@"Subscribed: %@", topic.topicString);
}

- (void)didUnsubscribe:(nonnull id<MPSubscriptionTopic>)topic {
    DEBUGLOG(@"Unsubscribed: %@", topic.topicString);
}

- (void)didUpdateState:(MPSubscriptionState)state {
    if (state == MPSubscriptionStateConnected) {
        if (self.ciscoDeviceId) {
            [self subscribeToCiscoDNAPositioning];
        } else {
            [self refreshDeviceInfo];
        }
    }
}

- (void)onError:(nonnull NSError *)error {
    [self refreshDeviceInfo];
}

- (void)onSubscriptionError:(nonnull NSError *)error topic:(nonnull id<MPSubscriptionTopic>)topic {
    [self refreshDeviceInfo];
}

- (void)onUnsubscriptionError:(nonnull NSError *)error topic:(nonnull id<MPSubscriptionTopic>)topic {
    
}

#pragma mark AFNetworking

- (void) reachabilityChanged: (NSNotification*) notif {
    
    if (self.isNetworkReachable != AFNetworkReachabilityManager.sharedManager.isReachable) {
    
        self.isNetworkReachable = AFNetworkReachabilityManager.sharedManager.isReachable;
        
    }
    
    if (AFNetworkReachabilityManager.sharedManager.isReachableViaWiFi) {
        
        [self refreshDeviceInfo];
        
    } else {
        
        [self unsubscribeCiscoDNAPositioning];
        [self clearDeviceInfo];
        
    }
    
}

@end
