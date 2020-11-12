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

/**
 Query object to be used with MPBookingService.getBookableLocationsUsingQuery()
 Queries are defined by a required timespan and a number of optional filter properties.
 */
@interface MPBookableQuery : NSObject

// Required timespan:
@property (nonatomic, strong,           nonnull ) NSDate*                   startTime;
@property (nonatomic, strong,           nonnull ) NSDate*                   endTime;

// Optional filter for what the found objects should be contained in:
@property (nonatomic, strong,           nullable) MPVenue*                  venue;
@property (nonatomic, strong,           nullable) MPBuilding*               building;
@property (nonatomic, strong,           nullable) NSNumber*                 floorIndex;
@property (nonatomic, strong,           nullable) MPLocation*               location;

// Optional category and locationType filter:
@property (nonatomic, strong,           nullable) NSString*                 category;
@property (nonatomic, strong,           nullable) NSString*                 locationType;

@end

NS_ASSUME_NONNULL_END
