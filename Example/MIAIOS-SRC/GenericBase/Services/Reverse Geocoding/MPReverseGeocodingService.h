//
//  MPReverseGeocodingService.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 24/01/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "MPLocation+ReverseGeocoding.h"


NS_ASSUME_NONNULL_BEGIN;


@class GMSReverseGeocodeResponse;


typedef void (^MPReverseGeocodeCallback)( GMSReverseGeocodeResponse* _Nullable, NSError* _Nullable );


@interface MPReverseGeocodingService : NSObject

+ (instancetype) sharedGeoCoder;

// Synchronous getters for cached content, will return nil when no cached reponses are available.
- (GMSReverseGeocodeResponse*) cachedReverseGeocodeResponseForCoordinate:(CLLocationCoordinate2D)coordinate;
- (GMSReverseGeocodeResponse*) cachedReverseGeocodeResponseForPoint:(MPPoint*)location;
- (GMSReverseGeocodeResponse*) cachedReverseGeocodeResponseForLocation:(MPLocation*)location;

// Asynchronous getters for reverse geocoding.
- (void) reverseGeocodeCoordinate:(CLLocationCoordinate2D)coordinate completionHandler:(MPReverseGeocodeCallback)handler;
- (void) reverseGeocodePoint:(MPPoint*)location completionHandler:(MPReverseGeocodeCallback)handler;
- (void) reverseGeocodeLocation:(MPLocation*)location completionHandler:(MPReverseGeocodeCallback)handler;

@end


NS_ASSUME_NONNULL_END;
