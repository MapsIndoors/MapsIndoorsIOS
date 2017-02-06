//
//  MPMapType.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 9/17/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 * Provides a static way to access the possible layer types for general purpose MapsPeople services
 */
@interface MPLayerType : NSObject
/**
 * Normal is the base map layer
 */
+ (NSString*)NORMAL;
/**
 * Satellite map layer
 */
+ (NSString*)SATELLITE;
/**
 * Hybrid is a satellite map layer with roads and tracks on top of it.
 */
+ (NSString*)HYBRID;

@end
