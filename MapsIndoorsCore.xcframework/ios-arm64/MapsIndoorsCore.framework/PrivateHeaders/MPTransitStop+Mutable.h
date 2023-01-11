//
//  MPTransitStop.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 24/11/2016.
//  Copyright  Daniel-Nielsen. All rights reserved.
//

#import "JSONModel.h"
#import "MPRouteCoordinate.h"


/**
 Transit stop information.
 */
@interface MPTransitStop()

@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* name;
@property (nonatomic, strong, nullable, readwrite) MPRouteCoordinate<Optional>* location;

@end
