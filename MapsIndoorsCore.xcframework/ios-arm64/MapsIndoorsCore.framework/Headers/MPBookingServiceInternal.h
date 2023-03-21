//
//  MPBookingService.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 06/07/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapsIndoors;

NS_ASSUME_NONNULL_BEGIN

typedef void (^mpBookingCompletion)( MPBooking* _Nullable booking, NSError* _Nullable error );
typedef void (^mpBookingListCompletion)( NSArray<MPBooking*>* _Nullable bookings, NSError* _Nullable error );
typedef void (^mpLocationListCompletion)( NSArray<id<MPLocation>>* _Nullable locations, NSError* _Nullable error );


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 MPBookingService allows for access to the MapsIndoors booking service.
 The booking service is a special integration that has to be enabled in the MapsIndoors cloud systems.

 The service allows for:
 - querying for bookable items, e.g. find a "meeting room from 10-12"
 - getting the current bookings for a user or a location, e.g. "when is this room booked"
 - booking and cancelling bookings.
 */
@interface MPBookingServiceInternal : NSObject<MPBookingService>

+ (instancetype) sharedInstance;

/**
 Set authentication configuration. This may be used if the Booking Service should book on behalf of an authenticated user. Otherwise the attempted bookings will be anonymous.
*/
@property (nonatomic, strong, nullable) MPBookingAuthConfig* authenticationConfig;

/**
 Query for bookable locations given the query filter.
 - Parameter q: filter to apply
 - Parameter completion: handler
 */
- (void)bookableLocationsUsingQuery:(MPBookableQuery * _Nonnull)query completionHandler:(void (^ _Nonnull)(NSArray<id<MPLocation>> * _Nullable, NSError * _Nullable))completionHandler;

/**
 Query for locations that are configured for booking given the query filter.
 - Parameter query: filter to apply
 - Parameter completion: handler
 */
- (void)locationsConfiguredForBooking:(MPBookableQuery * _Nonnull)query completionHandler:(void (^ _Nonnull)(NSArray<id<MPLocation>> * _Nullable, NSError * _Nullable))completionHandler;

/**
 Get existing booking according the the given ``MPBookingsQuery``
 - Parameter q: filter to apply
 - Parameter completion: handler
 */
- (void)bookingsUsingQuery:(MPBookingsQuery * _Nonnull)query completionHandler:(void (^ _Nonnull)(NSArray<MPBooking *> * _Nullable, NSError * _Nullable))completionHandler;
/**
 Book the resource identified by the booking parameter.
 - Parameter booking: identification of resource, timespan etc to book
 - Parameter completion: handler
 */
- (void)performBooking:(MPBooking * _Nonnull)booking completionHandler:(void (^ _Nonnull)(MPBooking * _Nullable, NSError * _Nullable))completionHandler;

/**
 Cancel the booking identified by the booking parameter.
 - Parameter booking: booking to cancel
 - Parameter completion: handler
*/
- (void)cancelBooking:(MPBooking * _Nonnull)booking completionHandler:(void (^ _Nonnull)(MPBooking * _Nullable, NSError * _Nullable))completionHandler;

@end


NS_ASSUME_NONNULL_END
