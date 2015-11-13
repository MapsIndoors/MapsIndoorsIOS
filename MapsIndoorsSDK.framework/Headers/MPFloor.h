//
//  MPFloor.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 1/13/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MPGeometry.h"
#ifdef USE_M4B
#import <GoogleMapsM4B/GoogleMaps.h>
#else
#import <GoogleMaps/GoogleMaps.h>
#endif

/**
 * Floor data model. Holds the floor geometry, display name, z-index and id of the building it belongs to. Furthermore it can hold a reference to a GMSTileLayer.
 */
@interface MPFloor : JSONModel
/**
 * Floor geometry.
 */
@property MPGeometry* geometry;
/**
 * The GMSTileLayer created to this floor.
 */
@property GMSTileLayer<Optional>* tileLayer;
/**
 * Floor layer style, if any.
 */
@property NSString<Optional>* style;
@property NSNumber<Optional>* zIndex;
@property NSString<Optional>* buildingId;
@property NSString* name;

@end
