//
//  MPTransitStop.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 24/11/2016.
//  Copyright  Daniel-Nielsen. All rights reserved.
//

#import "JSONModel.h"
#import "MPRouteProperty.h"

@interface MPTransitStop : JSONModel

//The name of the transit station/stop. eg. "Union Square".
@property NSString<Optional>* name;
//The location of the transit station/stop, represented as a lat and lng field.
@property MPRouteProperty<Optional>* location;

@end
