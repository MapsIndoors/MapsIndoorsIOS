//
//  MPRouteStep+Heading.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 23/04/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import "MPRouteStep.h"
#import <CoreLocation/CoreLocation.h>


NS_ASSUME_NONNULL_BEGIN

@interface MPRouteStep (Heading)

@property (nonatomic, readonly) const CLLocationDegrees heading;

@end

NS_ASSUME_NONNULL_END
