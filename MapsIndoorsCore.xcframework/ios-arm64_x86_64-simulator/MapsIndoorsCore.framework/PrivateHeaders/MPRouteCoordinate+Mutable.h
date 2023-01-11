//
//  MPRouteCoordinate+Mutable.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 26/08/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import "MPRouteCoordinate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPRouteCoordinate ()

@property (nonatomic, strong, readwrite) NSNumber<Optional>* zLevel;
@property (nonatomic, strong, readwrite) NSNumber* lat;
@property (nonatomic, strong, readwrite) NSNumber* lng;
@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* floor_name;
@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* label;

@end

NS_ASSUME_NONNULL_END
