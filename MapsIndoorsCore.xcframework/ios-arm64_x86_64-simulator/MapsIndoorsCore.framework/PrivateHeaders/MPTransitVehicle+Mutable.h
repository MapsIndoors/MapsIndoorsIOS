//
//  MPTransitVehicle.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 24/11/2016.
//  Copyright  Daniel-Nielsen. All rights reserved.
//

#import "JSONModel.h"

/**
 Transit vehicle information.
 */
@interface MPTransitVehicle()

@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* name;
@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* type;
@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* icon;
@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* local_icon;

@end
