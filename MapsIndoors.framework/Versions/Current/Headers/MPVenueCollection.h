//
//  MPVenueCollection.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 1/14/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import "MPJSONModel.h"
#import "MPBuilding.h"
#import "MPVenue.h"

/**
 Venue protocol specification
 */
@protocol MPVenue
@end
/**
 Venue collection model, just holds an array.
 */
@interface MPVenueCollection : MPJSONModel

/**
 The array of venues in this collection.
 */
@property NSArray<MPVenue>* venues;

- (MPBuilding*) getBuilding:(NSString*)buildingId;
- (MPVenue *)getNearestVenue:(MPPoint*)geometry withinRadius: (int)meterRadius;


@end
