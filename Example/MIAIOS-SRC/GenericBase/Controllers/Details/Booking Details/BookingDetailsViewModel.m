//
//  BookingDetailsViewModel.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 10/12/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "BookingDetailsViewModel.h"
#import "BookingDetailsEntry.h"


#define LATEST_HOUR_TO_SHOW     18


@interface BookingDetailsViewModel ()

@property (nonatomic, weak, readwrite) MPLocation*                          bookableLocation;
@property (nonatomic,       readwrite) BOOL                                 isBusy;
@property (nonatomic, strong) NSArray<NSNumber*>*                           availableDurationsInMinutes;
@property (nonatomic, strong, readwrite) NSArray<BookingDetailsEntry*>*     bookingEntries;
@property (nonatomic, strong, readwrite) NSError*                           error;

@end


@implementation BookingDetailsViewModel

+ (instancetype) newWithBookableLocation:(MPLocation*)loc {

    return [[self alloc] initWithBookableLocation:loc];
}


- (instancetype) initWithBookableLocation:(MPLocation*)loc {

    if ( loc == nil ) {
        self = nil;

    } else {

        self = [super init];
        if (self) {
            _bookableLocation = loc;
            _shouldShowBookingInformation = loc.isBookable;
            _isBusy = NO;
            _availableDurationsInMinutes = @[ @(30), @(60) ];
            _selectedDurationIndex = 0;
        }
    }

    return self;
}


#pragma mark - Booking Duration Support


- (NSArray<NSString*>*) availableDurations {

    NSMutableArray<NSString*>*  durations = [NSMutableArray array];
    NSDateComponentsFormatter*  fmt = [NSDateComponentsFormatter new];
    fmt.allowedUnits = NSCalendarUnitMinute | NSCalendarUnitHour;
    fmt.unitsStyle = NSDateComponentsFormatterUnitsStyleAbbreviated;

    for ( NSNumber* minutes in self.availableDurationsInMinutes ) {
        [durations addObject:[fmt stringFromTimeInterval:minutes.doubleValue*60]];
    }

    return [durations copy];
}


- (void) setSelectedDurationIndex:(NSUInteger)selectedDurationIndex {

    if ( _selectedDurationIndex != selectedDurationIndex ) {

        _selectedDurationIndex = selectedDurationIndex;

        [self refresh];
    }
}


#pragma mark - Booking entries


- (void) refresh {

    [self refreshWithCompletion:nil];
}


- (void) refreshWithCompletion:(nullable BookingRefreshCompletion)completion {

    self.isBusy = YES;

    [self i_refreshWithCompletion:^(NSError *error) {

        self.isBusy = NO;

        if ( completion ) {
            completion( error );
        }
    }];
}


- (void) i_refreshWithCompletion:(BookingRefreshCompletion)completion {

    // Figure out timespan we should query:
    NSDate*             now = [NSDate date];
    NSCalendar*         calendar = [NSCalendar currentCalendar];
    NSDateComponents*   comps = [calendar components: NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute fromDate: now];
    NSUInteger          timeslotDuration = self.availableDurationsInMinutes[ self.selectedDurationIndex ].unsignedIntegerValue;

    comps.minute -= (comps.minute % timeslotDuration);

    NSUInteger      originalHours = comps.hour;
    if ( comps.hour >= LATEST_HOUR_TO_SHOW ) {
        comps.hour = 8;
        comps.minute = 0;
    }

    NSDate* startDate = [calendar dateFromComponents:comps];
    if ( originalHours >= LATEST_HOUR_TO_SHOW ) {
        NSDateComponents*   oneDay = [NSDateComponents new];
        oneDay.day = 1;
        startDate = [calendar dateByAddingComponents:oneDay toDate:startDate options:NSCalendarWrapComponents];
    }

    NSUInteger  minutes = (LATEST_HOUR_TO_SHOW - comps.hour) * 60 - comps.minute;
    NSDate*     endDate = [startDate dateByAddingTimeInterval:minutes*60];

    MPBookingsQuery*    q = [MPBookingsQuery new];
    q.startTime = startDate;
    q.endTime = endDate;
    q.location = self.bookableLocation;
    [MPBookingService.sharedInstance getBookingsUsingQuery:q completion:^(NSArray<MPBooking *> * _Nullable bookings, NSError * _Nullable error) {

        if ( !error ) {

            NSMutableArray<BookingDetailsEntry*>*       entries = [NSMutableArray array];
            NSDate*                                     entryDate = startDate;
            NSUInteger                                  remainingMinutes = minutes;

            // Add free timeslots:
            for ( ; remainingMinutes > 0; remainingMinutes -= timeslotDuration ) {
                BookingDetailsEntry*    bookingForFreeTimeslot = [BookingDetailsEntry newWithStartTime:entryDate duration:timeslotDuration*60 location:self.bookableLocation];

                for ( MPBooking* existingBooking in bookings ) {

                    BOOL  timeslotStartsAfterExistingBooking = [bookingForFreeTimeslot.startTime compare:existingBooking.endTime] != NSOrderedAscending;
                    BOOL  timeslotEndsBeforeExistingBooking  = [bookingForFreeTimeslot.endTime compare:existingBooking.startTime] != NSOrderedDescending;

                    if ( timeslotStartsAfterExistingBooking || timeslotEndsBeforeExistingBooking ) {
                        // OK - free timeslot is not overlapping existingBooking
                    } else {
                        bookingForFreeTimeslot = nil;
                        break;
                    }
                }

                if ( bookingForFreeTimeslot ) {
                    [entries addObject: bookingForFreeTimeslot];
                }

                entryDate = [entryDate dateByAddingTimeInterval:timeslotDuration*60];
            }

            // Add existing bookings:
            for ( MPBooking* existingBooking in bookings ) {
                BookingDetailsEntry*    b = [BookingDetailsEntry newWithBooking:existingBooking];
                [entries addObject: b];
            }

            // Sort entries by startdate...
            [entries sortUsingComparator:^NSComparisonResult(BookingDetailsEntry* _Nonnull obj1, BookingDetailsEntry* _Nonnull obj2) {

                #if 0
                    // Instead of comparing the start dates, we compare the offset in seconds into the start date.
                    // This is because recurring bookings seems to have a start date at the first occurence of the meeting series,
                    // and not a date on the day we requested.
                    // More details here: https://mapspeople.slack.com/archives/C0175Q3E212/p1607982564033100
                    //
                    // MIBAPI-1786 [GSUITE] Add support for recurring events (https://mapspeople.atlassian.net/browse/MIBAPI-1786)
                    // should make this obsolete, and we can go back to just comparing 'startTimes'.
                    //
                    NSTimeInterval  t1 = (unsigned long long)[obj1.startTime timeIntervalSince1970] % 86400ull;
                    NSTimeInterval  t2 = (unsigned long long)[obj2.startTime timeIntervalSince1970] % 86400ull;

                    return [@(t1) compare:@(t2)];
                #endif

                return [obj1.startTime compare:obj2.startTime];
            }];

            self.bookingEntries = [entries copy];
        }

        self.error = error;

        completion( error );
    }];
}


- (void) performBooking:(BookingDetailsEntry*)entry completion:(BookingOperationCompletion)completion {

    if ( !entry.bookingInProgress ) {

        entry.bookingInProgress = YES;

        MPBooking*  b = entry.booking;
        [MPBookingService.sharedInstance performBooking:b completion:^(MPBooking * _Nullable booking, NSError * _Nullable error) {

            [self i_refreshWithCompletion:^( NSError* refreshError ) {

                NSSet<NSString*>*   bookingIds = [NSSet setWithArray:[self.bookingEntries valueForKeyPath:@"booking.bookingId"]];

                if ( [bookingIds containsObject:booking.bookingId] == YES ) {
                    entry.bookingInProgress = NO;
                    completion( entry, error ?: refreshError );

                } else {

                    // Sometimes the booking we successfully created is not in the list of current bookings, so we retry a little in the future...
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self i_refreshWithCompletion:^(NSError* refreshError) {
                            entry.bookingInProgress = NO;
                            completion( entry, error ?: refreshError );
                        }];
                    });
                }
            }];
        }];
    }
}


- (void) cancelBooking:(BookingDetailsEntry*)entry completion:(BookingOperationCompletion)completion {
    
    if ( !entry.bookingInProgress ) {

        entry.bookingInProgress = YES;

        MPBooking*  b = entry.booking;
        [MPBookingService.sharedInstance cancelBooking:b completion:^(MPBooking * _Nullable booking, NSError * _Nullable error) {

            [self i_refreshWithCompletion:^( NSError* refreshError ) {

                NSSet<NSString*>*   bookingIds = [NSSet setWithArray:[self.bookingEntries valueForKeyPath:@"booking.bookingId"]];

                if ( [bookingIds containsObject:booking.bookingId] == NO ) {
                    entry.bookingInProgress = NO;
                    completion( entry, error ?: refreshError );

                } else {

                    // Sometimes the booking we successfully deleted is STILL in the list of current bookings, so we retry a little in the future...
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self i_refreshWithCompletion:^(NSError* refreshError) {
                            entry.bookingInProgress = NO;
                            completion( entry, error ?: refreshError );
                        }];
                    });
                }
            }];
        }];
    }
}


@end
