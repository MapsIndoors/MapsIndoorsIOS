//
//  NSString+MPTravelMode.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 19/12/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPDirectionsQuery.h"       // This is where MPTravelMode lives...


@interface NSString (MPTravelMode)

- (MPTravelMode) as_MPTravelMode;

@end
