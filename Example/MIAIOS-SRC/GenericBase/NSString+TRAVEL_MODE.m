//
//  NSString+TRAVEL_MODE.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 03/03/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import "NSString+TRAVEL_MODE.h"

@implementation NSString (TRAVEL_MODE)

- (TRAVEL_MODE) as_TRAVEL_MODE {

    NSString*   selfLowercased = [self lowercaseString];
    
    if ( [selfLowercased isEqualToString:@"walking"] ) {
        return WALK;
    
    } else if ( [selfLowercased isEqualToString:@"bicycling"] ) {
        return BIKE;
        
    } else if ( [selfLowercased isEqualToString:@"driving"] ) {
        return DRIVE;
        
    } else if ( [selfLowercased isEqualToString:@"transit"] ) {
        return TRANSIT;
    }
    
    return WALK;
}

+ (NSString*) stringFromTravelMode:(TRAVEL_MODE)travelMode {
    
    NSString*   result = @"walking";
    
    switch ( travelMode ) {
        case WALK:      result = @"walking";        break;
        case BIKE:      result = @"bicycling";      break;
        case DRIVE:     result = @"driving";        break;
        case TRANSIT:   result = @"transit";        break;
    }
    
    return result;
}

- (MPTravelMode)as_MPTravelMode {
    
    switch ( [self as_TRAVEL_MODE] ) {
        case WALK:      return MPTravelModeWalking;
        case BIKE:      return MPTravelModeBicycling;
        case DRIVE:     return MPTravelModeDriving;
        case TRANSIT:   return MPTravelModeTransit;
    }
    
    return MPTravelModeWalking;
}

@end
