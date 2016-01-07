//
//  MPOnlineTileLayer.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 9/17/13.
//  Copyright (c) 2013 MapsPeople A/S. All rights reserved.
//

#ifdef USE_M4B
#import <GoogleMapsM4B/GoogleMaps.h>
#else
#import <GoogleMaps/GoogleMaps.h>
#endif
#import "MPVenue.h"
#import "MPFloor.h"

/**
 * Online tile layer. Used to serve a google map with a MapsPeople online tileservice.
 */
@interface MPOnlineTileLayer : NSObject {
    int _balancingIndex;
}

/**
 * The google GMSTileLayer object.
 */
@property GMSTileLayer* layer;
/**
 * Layer type / identifier.
 */
@property (nonatomic) NSString* layerType;
/**
 * Instantiate using a layer type.
 */
- (id)initWithLayer: (NSString*)layerType;
- (id)init;
/**
 * Helper method to generate the correct url, based on level and layer type.
 */
- (NSString*)getTileUrl: (NSUInteger)zoom x:(NSUInteger)x y:(NSUInteger)y;
/**
 * Add the layer to a map.
 * @param map The Google map view.
 */
- (void)addToMap:(GMSMapView*) map;

@end
