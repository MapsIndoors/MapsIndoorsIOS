//
//  MPCiscoPositionProvider.m
//  MIAIOS
//
//  Created by Daniel Nielsen on 07/04/14.
//  Copyright (c) 2014-2018 MapsPeople A/S. All rights reserved.
//

#define mBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
#define kCiscoPositionTestProxyUrl @"https://folia-customer.s3.amazonaws.com/ku/positionTest.json?id=%d"

#import "MPCiscoPositionProvider.h"
#import "MPCiscoPositionResponse.h"
#import "LocalizedStrings.h"
#import <UIKit/UIKit.h>
#import <MapsIndoors/MapsIndoors.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "MDDeviceHelper.h"

@implementation MPCiscoPositionProvider {
    NSString* _serviceUrl;
    BOOL _isRunning;
    UIAlertController* _wifiAlert;
    double _gpsAccuracy;
    double _mseAccuracy;
    NSDate* _latestMSEResultDate;
    NSDate* _latestGPSResultDate;
    BOOL _useBitShiftedIp;
}

@synthesize providerType = _providerType;
@synthesize latestPositionResult = _latestPositionResult;
@synthesize delegate = _delegate;

- (instancetype)initWithServiceUrl: (NSString*) url useBitShiftedIp: (BOOL) useBitShiftedIp {
    self = [super init];
    if (self) {
        _serviceUrl = url;
        _useBitShiftedIp = useBitShiftedIp;
    }
    return self;
}

-(void)startPositioning:(NSString *)arg {
    [super startPositioning:arg];
    if (!_isRunning) {
        _mseAccuracy = DBL_MAX;
        _gpsAccuracy = DBL_MAX;
        _isRunning = YES;
        self.interval = 2.0f;
        [self queryPosition];
    }
}

-(void)stopPositioning:(NSString *)arg {
    
    [super stopPositioning:arg];
    if (_isRunning) {
        _isRunning = NO;
    }
}

- (BOOL)isRunning {
    return _isRunning || [super isRunning];
}

- (void)setProviderType:(MPPositionProviderType)providerType {
    _providerType = providerType;
}

- (void)queryPosition {
    
    dispatch_async(mBgQueue, ^{
        
        
        
        NSString* ip = [self getIPAddress];
        
        if (self->_useBitShiftedIp) {
        
            NSArray *ipExplode = [[self getIPAddress] componentsSeparatedByString:@"."];
            
            if (ipExplode.count == 4) {
                
                int seg1 = [ipExplode[0] intValue];
                int seg2 = [ipExplode[1] intValue];
                int seg3 = [ipExplode[2] intValue];
                int seg4 = [ipExplode[3] intValue];
                
                uint32_t newIP = 0;
                newIP |= (uint32_t)((seg1 & 0xFF) << 24);
                newIP |= (uint32_t)((seg2 & 0xFF) << 16);
                newIP |= (uint32_t)((seg3 & 0xFF) << 8);
                newIP |= (uint32_t)((seg4 & 0xFF) << 0);
                
                ip = [NSString stringWithFormat:@"%@", @(newIP)];
                
            }
        }
            
        NSError* err = nil;
        
        if (ip) {
        
            NSString* url = [NSString stringWithFormat:self->_serviceUrl, ip];
            
            NSString* encodedUrl = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
            
            NSString* stringResp = [NSString stringWithContentsOfURL:[NSURL URLWithString:encodedUrl] encoding:NSUTF8StringEncoding error:&err];
            
            
            if (err == nil) {
                NSError* jsonErr = nil;

                MPCiscoPositionResponse* resp = [[MPCiscoPositionResponse alloc] initWithString:stringResp error:&jsonErr];
                if ([self isRunning]) {
                    if (!jsonErr && resp != nil) {
                        if ([resp.status isEqualToNumber:[[NSNumber alloc] initWithInt:200]]) {
                            MPPositionResult* res = ((MPPositionResult*)resp.result);
                            res.provider = self;
                            
                            void (^usePosition)(void) = ^void() {
                                [res.geometry setZValue:[[res getFloor] doubleValue]];
                                self.latestPositionResult = res;
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    if (self.delegate) [self.delegate onPositionUpdate:res];
                                });
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"PositionUpdate" object: self.latestPositionResult];
                            };
                            
                            NSNumber* floor = [res getFloor];
                            if (floor && res.geometry.coordinates.count >= 2) {
                                
                                self->_mseAccuracy = [res getProbability];
                                self->_latestMSEResultDate = [NSDate date];
                                
                                if ([self shouldDetermineBestPosition]){
                                    if (self->_mseAccuracy < self->_gpsAccuracy) {
                                        usePosition();
                                    }
                                } else {
                                    usePosition();
                                }
                            } else {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    if (self.delegate) [self.delegate onPositionFailed:self];
                                });
                            }
                        } else {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                if (self.delegate) [self.delegate onPositionFailed:self];
                            });
                        }
                    } else if (self.delegate) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self.delegate onPositionFailed:self];
                        });
                    }
                }
            }
        } else {
            if (!self->_wifiAlert) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self->_wifiAlert = [UIAlertController alertControllerWithTitle:kLangPleaseEnableWIFI message:kLangEnableWIFIToGetPositioning preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:@"OK"
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)
                                         {
                        [self->_wifiAlert dismissViewControllerAnimated:YES completion:nil];
                                             
                                         }];
                    [self->_wifiAlert addAction:ok];
                    //_wifiAlert = [[UIAlertView alloc] initWithTitle:kLangPlease_enable_WIFI message:kLangEnableWIFIToGetPositioning delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    if (!(IS_IPAD)) {
                        self->_wifiAlert.modalPresentationStyle = UIModalPresentationFullScreen;
                    }
                    
                    [[UIApplication sharedApplication].windows.firstObject.rootViewController presentViewController:self->_wifiAlert animated:YES completion:nil];
                    
                });
            }
        }
        
        if ([self isRunning]) {
            // Schedule next periodic update of position:
            // NOTE When -[NSObject performSelector:withObject:afterDelay:] is called on a threads that have a runloop, it fails silently!
            // So perform the update on the mainqueue/thread, so we are sure to have a runloop.
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSelector:@selector(queryPosition) withObject:nil afterDelay:self.interval];
            });
        }
    });
}

- (float)randomFloatBetween:(float)smallNumber and:(float)bigNumber {
    float diff = bigNumber - smallNumber;
    return (((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * diff) + smallNumber;
}

- (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

- (void)startPositioningAfter:(int)millis arg:(NSString *)arg {
    [self performSelector:@selector(startPositioning:) withObject:arg afterDelay:millis];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation* l = locations.firstObject;
    if (l != nil) {
        
        _gpsAccuracy = l.horizontalAccuracy;
        _latestGPSResultDate = [NSDate date];
        
        if ([self shouldDetermineBestPosition]) {
            if (_gpsAccuracy < _mseAccuracy) {
                [super locationManager:manager didUpdateLocations:locations];
            }
        } else {
            [super locationManager:manager didUpdateLocations:locations];
        }
    }
}

- (BOOL) shouldDetermineBestPosition {
    NSDate* now = [NSDate date];
    return ([now timeIntervalSinceDate:_latestGPSResultDate] < 5.0 && [now timeIntervalSinceDate:_latestMSEResultDate] < 5.0);
}

@end
