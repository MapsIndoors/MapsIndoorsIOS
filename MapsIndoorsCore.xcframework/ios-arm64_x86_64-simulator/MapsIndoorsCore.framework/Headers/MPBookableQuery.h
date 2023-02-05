//
//  MPBookableQuery.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 07/07/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MPVenue;
@class MPBuilding;
@class MPFloor;
@class MPLocation;


NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Query object to be used with MPBookingService.getBookableLocationsUsingQuery()
 Queries are defined by a required timespan and a number of optional filter properties.
 */
@interface MPBookableQuery : NSObject

/// Required start date for your potential booking.
@property (nonatomic, strong,           nonnull ) NSDate*                   startTime;

/// Required end date for your potential booking.
@property (nonatomic, strong,           nonnull ) NSDate*                   endTime;

/// Optional filter for which Venue the found Locations should be contained in.
@property (nonatomic, strong,           nullable) MPVenue*                  venue;

/// Optional filter for which Building the found Locations should be contained in.
@property (nonatomic, strong,           nullable) MPBuilding*               building;

/// Optional filter for which Floor the found Locations should belong to.
@property (nonatomic, strong,           nullable) NSNumber*                 floorIndex;

/// Optional filter for which Location the found Locations should either be or be contained in.
@property (nonatomic, strong,           nullable) MPLocation*               location;

/// Optional filter for which Category the found Locations should belong to.
@property (nonatomic, strong,           nullable) NSString*                 category;

/// Optional filter for what the found Locations should belong to.
@property (nonatomic, strong,           nullable) NSString*                 locationType;

@end

NS_ASSUME_NONNULL_END
