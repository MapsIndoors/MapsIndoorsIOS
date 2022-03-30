//
//  BookingDetailsViewModel.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 10/12/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <MapsIndoors/MapsIndoors.h>

NS_ASSUME_NONNULL_BEGIN

@class BookingDetailsEntry;
typedef void (^BookingRefreshCompletion)( NSError* error );
typedef void (^BookingOperationCompletion)( BookingDetailsEntry* entry, NSError* error );


@interface BookingDetailsViewModel : NSObject

@property (nonatomic, weak, readonly) MPLocation*                           bookableLocation;
@property (nonatomic, readonly)       BOOL                                  isBusy;
@property (nonatomic, readonly)       BOOL                                  shouldShowBookingInformation;

@property (nonatomic, strong, readonly) NSArray<NSString*>*                 availableDurations;
@property (nonatomic) NSUInteger                                            selectedDurationIndex;

@property (nonatomic, strong, readonly) NSArray<BookingDetailsEntry*>*      bookingEntries;
@property (nonatomic, strong, readonly) NSError*                            error;

+ (instancetype) new NS_UNAVAILABLE;
- (instancetype) init NS_UNAVAILABLE;

+ (instancetype) newWithBookableLocation:(MPLocation* _Nullable)loc;
- (instancetype) initWithBookableLocation:(MPLocation* _Nullable)loc;

- (void) refresh;
- (void) refreshWithCompletion:(nullable BookingRefreshCompletion)completion;

- (void) performBooking:(BookingDetailsEntry*)entry completion:(BookingOperationCompletion)completion;
- (void) cancelBooking:(BookingDetailsEntry*)entry completion:(BookingOperationCompletion)completion;

@end

NS_ASSUME_NONNULL_END
