//
//  NSString+TRAVEL_MODE.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 03/03/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"
#import <MapsIndoors/MPDirectionsQuery.h>


@interface NSString (TRAVEL_MODE)

- (TRAVEL_MODE) as_TRAVEL_MODE;
+ (NSString*) stringFromTravelMode:(TRAVEL_MODE)travelMode;

- (MPTravelMode) as_MPTravelMode;

@end
