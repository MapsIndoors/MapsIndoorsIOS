//
//  MPTransitStopInternal.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 24/11/2016.
//  Copyright  Daniel-Nielsen. All rights reserved.
//

#import "JSONModel.h"
#import "MPRouteCoordinateInternal.h"
@import MapsIndoors;

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Transit stop information.
 */
@interface MPTransitStopInternal : JSONModel <MPTransitStop>

/**
 The name of the transit station/stop. eg. "Union Square".
 */
@property (nonatomic, copy, nullable) NSString* name;

/**
 The location of the transit station/stop, represented as a lat and lng field.
 */
@property (nonatomic, strong, nullable) MPRouteCoordinateInternal* location;

@end
