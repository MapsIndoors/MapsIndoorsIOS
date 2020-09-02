//
//  MPFloor.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 1/13/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import "MPJSONModel.h"
#import "MPGeometry.h"
#import <GoogleMaps/GoogleMaps.h>

/**
 Floor data model. Holds the floor geometry, display name, z-index and id of the building it belongs to. Furthermore it can hold a reference to a GMSTileLayer.
 */
@interface MPFloor : MPJSONModel

/// Floor id
@property (nonatomic, strong, nonnull, readonly) NSString* floorId;
/**
 Floor geometry.
 */
//@property MPGeometry* geometry;
/**
 The GMSTileLayer created to this floor.
 */
@property (nonatomic, strong, nullable) GMSTileLayer<Optional>* tileLayer;
/**
 Floor layer style, if any.
 */
@property (nonatomic, strong, nullable) NSString<Optional>* style;
/// Floor index
@property (nonatomic, strong, nullable) NSNumber<Optional>* zIndex;
@property (nonatomic, strong, nullable) NSString<Optional>* buildingId;
@property (nonatomic, strong, nullable) NSArray<NSArray*>* bounds;
@property (nonatomic, strong, nullable) NSString* name;

@end
