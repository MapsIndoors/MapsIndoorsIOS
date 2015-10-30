//
//  MPVenueCollection.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 1/14/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MPBuilding.h"

/**
 * Venue protocol specification
 */
@protocol MPVenue
@end
/**
 * Venue collection model, just holds an array.
 */
@interface MPVenueCollection : JSONModel

/**
 * The array of venues in this collection.
 */
@property NSArray<MPVenue>* venues;

- (MPBuilding*) getBuilding:(NSString*)buildingId;

@end
