//
//  BookingDetailsEntry.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 10/12/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <MapsIndoors/MapsIndoors.h>


NS_ASSUME_NONNULL_BEGIN

@interface BookingDetailsEntry : NSObject

@property (nonatomic, strong, readonly) NSDate*         startTime;
@property (nonatomic, strong, readonly) NSDate*         endTime;
@property (nonatomic, strong, readonly) MPBooking*      booking;
@property (nonatomic, strong          ) NSString*       descriptionText;
@property (nonatomic, strong, readonly) NSString*       actionText;
@property (nonatomic,         readonly) BOOL            isBookable;
@property (nonatomic,         readonly) BOOL            isCancellable;
@property (nonatomic                  ) BOOL            bookingInProgress;
@property (nonatomic, weak  , readonly) MPLocation*     location;

+ (instancetype) new NS_UNAVAILABLE;
- (instancetype) init NS_UNAVAILABLE;

+ (instancetype) newWithBooking:(MPBooking*)b fitToTimeslotFrom:(NSDate*)startTime to:(NSDate*)endTime;
+ (instancetype) newWithBooking:(MPBooking*)b;
+ (instancetype) newWithStartTime:(NSDate*)startTime duration:(NSTimeInterval)duration location:(MPLocation*)location;

@end

NS_ASSUME_NONNULL_END
