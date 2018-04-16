//
//  MPReverseGeocodingService.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 24/01/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "MPReverseGeocodingService.h"
#import "MPLocation+ReverseGeocoding.h"
#import <MapsIndoors/MPPoint.h>
#import <GoogleMaps/GMSGeocoder.h>


#if DEBUG && 0
#   define DEBUGLOG(fMT,...)  NSLog( @"[D] MPReverseGeocodingService(%d): "fMT,  __LINE__, __VA_ARGS__ )
#else
#   define DEBUGLOG(fMt,...)  /* Nada! */
#endif


@interface MPReverseGeocodingService ()

@property (nonatomic, strong) GMSGeocoder*                                                      geocoder;
@property (nonatomic, strong) NSMutableDictionary<NSString*,GMSReverseGeocodeResponse*>*        cache;

@end


@implementation MPReverseGeocodingService

+ (instancetype) sharedGeoCoder {
    
    static MPReverseGeocodingService*  _sharedReverseGeocodingService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedReverseGeocodingService = [MPReverseGeocodingService new];
    });
    
    return _sharedReverseGeocodingService;
}

- (instancetype) init {
    
    self = [super init];
    if (self) {
        _cache = [NSMutableDictionary dictionary];
        _geocoder = [GMSGeocoder geocoder];
    }
    return self;
}
    
+ (NSString*) cacheKeyForCoordinate:(CLLocationCoordinate2D)coordinate {

    return [NSString stringWithFormat:@"%@_%@", @(coordinate.latitude), @(coordinate.longitude)];
}

- (GMSReverseGeocodeResponse*) cachedReverseGeocodeResponseForCoordinate:(CLLocationCoordinate2D)coordinate {

    return [self.cache objectForKey:[MPReverseGeocodingService cacheKeyForCoordinate:coordinate]];
}

- (GMSReverseGeocodeResponse*) cachedReverseGeocodeResponseForPoint:(MPPoint *)location {
    
    CLLocationCoordinate2D  coordinate = [location getCoordinate];
    return [self cachedReverseGeocodeResponseForCoordinate:coordinate];
}

- (GMSReverseGeocodeResponse*) cachedReverseGeocodeResponseForLocation:(MPLocation *)location {
    
    if ( location.mp_reverseGeocodingResponse == nil ) {
        
        CLLocationCoordinate2D  coordinate = [[location getPoint] getCoordinate];
        GMSReverseGeocodeResponse*  reverseGeocodeResponse = [self cachedReverseGeocodeResponseForCoordinate:coordinate];
        
        location.mp_reverseGeocodingResponse = reverseGeocodeResponse;
    }
    
    return location.mp_reverseGeocodingResponse;
}

- (void) reverseGeocodeCoordinate:(CLLocationCoordinate2D)coordinate completionHandler:(MPReverseGeocodeCallback)handler {
    
    GMSReverseGeocodeResponse* reverseGeocodeResponse = [self cachedReverseGeocodeResponseForCoordinate:coordinate];
    
    if ( reverseGeocodeResponse ) {

        dispatch_async( dispatch_get_main_queue(), ^{
            DEBUGLOG( @"ReverseGeocoding response from cache: %@", [MPReverseGeocodingService cacheKeyForCoordinate:coordinate] );
            handler( reverseGeocodeResponse, nil );
        });

    } else {
        
        DEBUGLOG( @"Begin ReverseGeocoding for %@", [MPReverseGeocodingService cacheKeyForCoordinate:coordinate] );
        [self.geocoder reverseGeocodeCoordinate:coordinate completionHandler:^(GMSReverseGeocodeResponse * _Nullable response, NSError * _Nullable error) {
        
            DEBUGLOG( @"Response ReverseGeocoding for %@: %@ (error %@)", [MPReverseGeocodingService cacheKeyForCoordinate:coordinate], response, error );
            
            if ( response && !error ) {
                NSString*   cacheKey = [MPReverseGeocodingService cacheKeyForCoordinate:coordinate];
                self.cache[ cacheKey ] = [response copy];
            }
            
            handler( response, error );
        }];
    }
}

- (void) reverseGeocodePoint:(MPPoint*)location completionHandler:(MPReverseGeocodeCallback)handler {
    
    CLLocationCoordinate2D  coordinate = [location getCoordinate];
    [self reverseGeocodeCoordinate:coordinate completionHandler:handler];
}

- (void) reverseGeocodeLocation:(MPLocation*)location completionHandler:(MPReverseGeocodeCallback)handler {

    if ( location.mp_reverseGeocodingResponse ) {
        
        dispatch_async( dispatch_get_main_queue(), ^{
            DEBUGLOG( @"ReverseGeocoding response from cached MPLocation.mp_reverseGeocodingResponse (<MPLocation %p>)", location );
            handler( location.mp_reverseGeocodingResponse, nil );
        });
        
    } else {
        
        CLLocationCoordinate2D  coordinate = [[location getPoint] getCoordinate];
        [self reverseGeocodeCoordinate:coordinate completionHandler:^(GMSReverseGeocodeResponse * _Nullable response, NSError * _Nullable error) {
            
            if ( response && !error ) {
                DEBUGLOG( @"ReverseGeocoding response, attaching to <MPLocation %p>", location );
                location.mp_reverseGeocodingResponse = response;
            }
            
            handler( response, error );
        }];
    }
}

@end
