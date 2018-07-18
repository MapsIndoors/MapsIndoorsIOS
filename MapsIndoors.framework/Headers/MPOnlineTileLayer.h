//
//  MPOnlineTileLayer.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 9/17/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import "MPVenue.h"
#import "MPFloor.h"

/**
 Online tile layer. Used to serve a google map with a MapsPeople online tileservice.
 */
@interface MPOnlineTileLayer : NSObject {
    int _balancingIndex;
}

/**
 The google GMSTileLayer object.
 */
@property (nonatomic, strong, nullable) GMSTileLayer* layer;

/**
 Layer type / identifier.
 */
@property (nonatomic, strong, nullable) NSString* layerType;

/**
 Instantiate using a layer type.
 */
- (nullable instancetype)initWithLayer: (nonnull NSString*)layerType;

/**
 Helper method to generate the correct url, based on level and layer type.
 */
- (nullable NSString*)getTileUrl: (NSUInteger)zoom x:(NSUInteger)x y:(NSUInteger)y;

/**
 Add the layer to a map.
 @param  map The Google map view.
 */
- (void)addToMap:(nullable GMSMapView*) map;

@end
