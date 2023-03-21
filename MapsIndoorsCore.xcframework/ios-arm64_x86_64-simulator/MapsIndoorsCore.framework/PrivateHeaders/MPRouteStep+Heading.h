//
//  MPRouteStepInternal+Heading.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 23/04/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import "MPRouteStepInternal.h"
#import <CoreLocation/CoreLocation.h>


NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPRouteStepInternal (Heading)

@property (nonatomic, readonly) const CLLocationDegrees heading;

@end

NS_ASSUME_NONNULL_END
