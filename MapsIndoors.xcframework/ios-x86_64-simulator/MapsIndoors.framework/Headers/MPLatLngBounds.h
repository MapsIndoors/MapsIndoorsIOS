//
//  MPLatLngBounds.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 11/5/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPLatLng.h"
@import JSONModel;

@interface MPLatLngBounds : JSONModel

@property (nonatomic, strong, nullable) MPLatLng* southWest;
@property (nonatomic, strong, nullable) MPLatLng* northEast;

@end
