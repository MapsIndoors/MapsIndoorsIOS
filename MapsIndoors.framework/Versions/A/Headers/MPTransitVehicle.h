//
//  MPTransitVehicle.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 24/11/2016.
//  Copyright  Daniel-Nielsen. All rights reserved.
//

#import "MPJSONModel.h"

@interface MPTransitVehicle : MPJSONModel

//name contains the name of the vehicle on this line. eg. "Subway."
@property (nonatomic, strong, nullable) NSString<Optional>* name;
//type contains the type of vehicle that runs on this line. See the Vehicle Type documentation for a complete list of supported values.
@property (nonatomic, strong, nullable) NSString<Optional>* type;
//icon contains the URL for an icon associated with this vehicle type.
@property (nonatomic, strong, nullable) NSString<Optional>* icon;
//local_icon contains the URL for the icon associated with this vehicle type, based on the local transport signage.
@property (nonatomic, strong, nullable) NSString<Optional>* local_icon;

@end
