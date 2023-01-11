//
//  MPBookingService.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 06/07/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "MPBookingService.h"

typedef NS_ENUM(NSUInteger, MPBookableState) {
    MPBookableStateAvailable = 0,
    MPBookableStateConfiguredForBooking = 1
};


@interface MPBookingService (Private)

- (NSString*) urlForBookingsUsingQuery:(MPBookingsQuery*)q;
- (NSString*) urlForCreatingBooking:(MPBooking*)booking;
- (NSString*) urlForDeletingBooking:(MPBooking*)booking;
- (NSString*)urlForLocationsUsingQuery:(MPBookableQuery*)q bookableState:(MPBookableState)bookableState;

@end
