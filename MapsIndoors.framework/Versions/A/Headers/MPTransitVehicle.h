//
//  MPTransitVehicle.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 24/11/2016.
//  Copyright © 2016 Daniel-Nielsen. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MPTransitVehicle : JSONModel

//name contains the name of the vehicle on this line. eg. "Subway."
@property NSString<Optional>* name;
//type contains the type of vehicle that runs on this line. See the Vehicle Type documentation for a complete list of supported values.
@property NSString<Optional>* type;
//icon contains the URL for an icon associated with this vehicle type.
@property NSString<Optional>* icon;
//local_icon contains the URL for the icon associated with this vehicle type, based on the local transport signage.
@property NSString<Optional>* local_icon;

@end
