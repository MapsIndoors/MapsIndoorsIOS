//
//  MPLatLng.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 11/5/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface MPLatLng : JSONModel

@property (readonly) double lat;
@property (readonly) double lng;

@end
