//
//  MPBookingAuthConfig.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 21/09/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// Booking authentication configuration model. This may be used if the `MPBookingService` should book on behalf of an authenticated user.
/// > Warning: [INTERNAL - DO NOT USE]
@interface MPBookingAuthConfig : NSObject
- (instancetype)init NS_UNAVAILABLE;

/// Constructor that takes an access token
/// @param accessToken The access token to use when performing bookings.
- (instancetype)initWithAccessToken:(NSString*)accessToken;

/// Set the access token that must be used when performing bookings.
@property (nonatomic, strong) NSString* accessToken;

/// Set the tenant id that must be used when performing bookings. This is relevant in scenarios where a location can be booked in more than one tenant.
@property (nonatomic, strong, nullable) NSString* tenantId;

@end

NS_ASSUME_NONNULL_END
