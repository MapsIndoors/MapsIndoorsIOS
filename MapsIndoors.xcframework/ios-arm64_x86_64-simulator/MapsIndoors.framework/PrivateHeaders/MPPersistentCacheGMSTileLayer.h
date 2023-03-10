//
//  MPPersistentCacheGMSTileLayer.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 08/12/15.
//  Copyright © 2015 MapsPeople A/S. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

@class MPFloor;
@class MPVenue;

@interface MPPersistentCacheGMSTileLayer : GMSTileLayer

/**
* Instantiate using a venue and a floor object.
*/
- (nullable instancetype)initWithVenue: (nullable MPVenue*)venue andFloor:(nullable MPFloor*)floor;

/**
 The url template string to use when fetching tiles. Must have format "prefix{param_1}infix{param_N}suffix", e.g.: "http://tiles.url.com/{floor}/{x}/{y}/{zoom}.png"
   By default the implementation of this tilelayer will look for {venueId}/{style}/{buildingId}/{floor}/{z}/{x}/{y}, where x, y and z is mandatory.
 */
@property (nonatomic, strong, nullable) NSString* urlTemplate;

/**
 Floor property
 */
@property (nonatomic, strong, nullable) MPFloor* floor;

/**
 Venue id
 */
@property (nonatomic, strong, nullable) NSNumber* venueId;

/**
 Array of strings identifying subdomains. If this property is set, and the url template contains the parameter {subdomain}, the tilelayer will do round-robin over the subdomains specified.
 */
@property (nonatomic, strong, nullable) NSArray* subdomains;

/**
 Set the url template to base the tilelayer on
 */
- (void)setUrlTemplate:(nonnull NSString *)urlTemplate;

/**
 Parse the url template. Normally, this is done automatically
 */
- (void)parseUrl;

@end
