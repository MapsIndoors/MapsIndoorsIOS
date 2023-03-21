//
//  MPBookingService.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 06/07/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "MPBookingServiceInternal.h"

typedef NS_ENUM(NSUInteger, MPBookableState) {
    MPBookableStateAvailable = 0,
    MPBookableStateConfiguredForBooking = 1
};


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPBookingServiceInternal (Private)

- (NSString*) urlForBookingsUsingQuery:(MPBookingsQuery*)q;
- (NSString*) urlForCreatingBooking:(MPBooking*)booking;
- (NSString*) urlForDeletingBooking:(MPBooking*)booking;
- (NSString*)urlForLocationsUsingQuery:(MPBookableQuery*)q bookableState:(MPBookableState)bookableState;

@end
