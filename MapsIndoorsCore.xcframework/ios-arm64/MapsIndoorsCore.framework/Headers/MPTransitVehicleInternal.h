//
//  MPTransitVehicleInternal.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 24/11/2016.
//  Copyright  Daniel-Nielsen. All rights reserved.
//

#import "JSONModel.h"
@import MapsIndoors;

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Transit vehicle information.
 */
@interface MPTransitVehicleInternal : JSONModel <MPTransitVehicle>

/**
 Name contains the name of the vehicle on this line. eg. "Subway."
 */
@property (nonatomic, copy, nullable) NSString* name;

/**
 Type contains the type of vehicle that runs on this line. See the Vehicle Type documentation for a complete list of supported values.
 */
@property (nonatomic, copy, nullable) NSString* type;

/**
 Icon contains the URL for an icon associated with this vehicle type.
 */
@property (nonatomic, copy, nullable) NSString* icon;

/**
 Local icon contains the URL for the icon associated with this vehicle type, based on the local transport signage.
 */
@property (nonatomic, copy, nullable) NSString* local_icon;

@end
