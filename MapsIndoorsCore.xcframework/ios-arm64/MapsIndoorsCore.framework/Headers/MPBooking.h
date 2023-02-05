//
//  MPBooking.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 07/07/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MPLocation;


NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 MPBooking represents an existing booking object or a booking to be made.
 bookingId will be non-null for an existing booking, and null for a booking to be made.
 */
@interface MPBooking : NSObject

@property (nonatomic, strong, readonly, nullable) NSString*                 bookingId;
@property (nonatomic, strong, readonly, nullable) NSString*                 locationId;
@property (nonatomic,   weak,           nullable) MPLocation*               location;
@property (nonatomic, strong,           nullable) NSDate*                   startTime;
@property (nonatomic, strong,           nullable) NSDate*                   endTime;
@property (nonatomic, strong,           nullable) NSArray< NSString* >*     participantIds;
@property (nonatomic, strong,           nullable) NSString*                 title;
@property (nonatomic, strong,           nullable) NSString*                 bookingDescription;
@property (nonatomic,         readonly          ) BOOL                      isManaged;              //! Indicates whether this booking is managed by the MapsIndoors Booking Service or has been created by other means. Managed bookings are cancellable by the booking service.

@end

NS_ASSUME_NONNULL_END
