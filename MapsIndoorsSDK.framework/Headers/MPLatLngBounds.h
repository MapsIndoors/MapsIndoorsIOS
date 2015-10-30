//
//  MPLatLngBounds.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 11/5/13.
//  Copyright (c) 2013 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPLatLng.h"
#import <JSONModel/JSONModel.h>

@interface MPLatLngBounds : JSONModel

@property MPLatLng* southWest;
@property MPLatLng* northEast;

@end
