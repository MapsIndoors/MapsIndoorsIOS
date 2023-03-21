//
//  MPVenueCollection.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 1/14/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"

@class MPBuildingInternal;
@class MPPoint;
@class MPVenueInternal;
@protocol MPVenueInternal;

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Venue collection model, just holds an array.
 */
@interface MPVenueCollection : JSONModel

/**
 The array of venues in this collection.
 */
@property (nonatomic, strong, nullable) NSArray<MPVenueInternal*><MPVenueInternal>* venues;

- (nullable MPBuildingInternal*) getBuilding:(nullable NSString*)buildingId;

- (nullable MPVenueInternal*)getNearestVenue:(nonnull MPPoint*)geometry withinRadius:(int)meterRadius;

@end
