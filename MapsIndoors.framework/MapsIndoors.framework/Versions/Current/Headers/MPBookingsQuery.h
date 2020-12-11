//
//  MPBookingsQuery.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 07/07/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MPLocation;


NS_ASSUME_NONNULL_BEGIN

/**
 Query object to be used with MPBookingService.getBookingsUsingQuery()
 Queries can be either for a location or a user (organizerId), and may optionally be limited to a given timespan.
 */
@interface MPBookingsQuery : NSObject

@property (nonatomic, strong,           nullable) MPLocation*               location;
@property (nonatomic, strong,           nullable) NSString*                 organizerId;
@property (nonatomic, strong,           nullable) NSDate*                   startTime;
@property (nonatomic, strong,           nullable) NSDate*                   endTime;

@end

NS_ASSUME_NONNULL_END
