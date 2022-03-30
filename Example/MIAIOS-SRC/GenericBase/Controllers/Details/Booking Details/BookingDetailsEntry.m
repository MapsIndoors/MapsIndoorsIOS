//
//  BookingDetailsEntry.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 10/12/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "BookingDetailsEntry.h"


@interface BookingDetailsEntry ()

@property (nonatomic, strong, readonly, class) NSDateFormatter*     timeFormatter;
@property (nonatomic, strong, readwrite) MPBooking*                 booking;

@end


@implementation BookingDetailsEntry

+ (NSDateFormatter*) timeFormatter {

    static NSDateFormatter*  _sharedTimeFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedTimeFormatter = [NSDateFormatter new];
        _sharedTimeFormatter.timeStyle = NSDateFormatterShortStyle;
        _sharedTimeFormatter.dateStyle = NSDateFormatterNoStyle;
    });

    return _sharedTimeFormatter;
}

+ (instancetype) newWithBooking:(MPBooking*)b fitToTimeslotFrom:(NSDate*)startTime to:(NSDate*)endTime {
    return [[self alloc] initWithBooking:b fitToTimeslotFrom:startTime to:endTime];
}

+ (instancetype) newWithBooking:(MPBooking*)b {
    return [[self alloc] initWithBooking:b];
}

- (instancetype) initWithBooking:(MPBooking*)b fitToTimeslotFrom:(NSDate*)startTime to:(NSDate*)endTime {
    self = [self initWithBooking:b];
    if (self) {
        _startTime = startTime;
        _endTime = endTime;
        _descriptionText = [self formatDescriptionText];
    }
    return self;
}

- (instancetype) initWithBooking:(MPBooking*)b {
    self = [super init];
    if (self) {
        _booking = b;
        _startTime = b.startTime;
        _endTime = b.endTime;
        _isBookable = NO;
        _isCancellable = b.isManaged;
        _descriptionText = [self formatDescriptionText];
        _location = b.location;
    }

    return self;
}

+ (instancetype) newWithStartTime:(NSDate*)startTime duration:(NSTimeInterval)duration location:(MPLocation*)location {
    return [[self alloc] initWithStartTime:startTime duration:duration location:location];
}

- (instancetype) initWithStartTime:(NSDate*)startTime duration:(NSTimeInterval)duration location:(MPLocation*)location {
    self = [super init];
    if (self) {
        _location = location;
        _startTime = startTime;
        _endTime = [startTime dateByAddingTimeInterval:duration];
        _isBookable = YES;
        _isCancellable = NO;
        _descriptionText = [self formatDescriptionText];
    }

    return self;
}

- (NSString*) formatDescriptionText {

// Uncomment to include booking title in the description.
//    NSString*   title = _booking ? self.booking.title : nil;
//    NSString*   desc = [title stringByTrimmingCharactersInSet:NSCharacterSet.whitespaceCharacterSet];
//
//    if ( desc.length ) {
//        return [NSString stringWithFormat: @"%@ - %@\n%@", [BookingDetailsEntry.timeFormatter stringFromDate:self.startTime], [BookingDetailsEntry.timeFormatter stringFromDate:self.endTime], desc];
//    }

    return [NSString stringWithFormat: @"%@ - %@", [BookingDetailsEntry.timeFormatter stringFromDate:self.startTime], [BookingDetailsEntry.timeFormatter stringFromDate:self.endTime]];
}


- (MPBooking*) booking {

    if ( _booking ) {       // Entry represents an existing booking
        return _booking;

    } else {

        MPBooking*  b = [MPBooking new];
        b.location = self.location;
        b.startTime = self.startTime;
        b.endTime = self.endTime;
//        b.title = [NSString stringWithFormat: NSLocalizedString( @"Booked from %@", ), UIDevice.currentDevice.name];
        b.title = NSLocalizedString( @"Booked", );
        b.bookingDescription = b.title;
        b.participantIds = @[];
        return b;
    }
}


- (NSString*) debugDescription {

    return [NSString stringWithFormat:@"<BookingDetailsEntry %@-%@ %@ (%@, %@)>", [BookingDetailsEntry.timeFormatter stringFromDate:self.startTime], [BookingDetailsEntry.timeFormatter stringFromDate:self.endTime], self.booking.title, self.booking.startTime, self.booking.bookingId];
}

@end
