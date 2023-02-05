//
//  MPPositionResult.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 10/03/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPPoint.h"
#import "JSONModel.h"


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Position result model
 */
@interface MPPositionResult : JSONModel

- (_Nullable instancetype) initWithWirelessPositionData:(nonnull NSData*) positionData;

/**
 The geographic point geometry of the position
 */
@property (nonatomic, strong, nullable) MPPoint* geometry;

/**
 The availability of the heading, returns NO if heading is not available, default is YES
 */
@property (nonatomic) BOOL headingAvailable;

/**
 Properties dictionary
 */
@property (nonatomic, strong, nullable) NSMutableDictionary* properties;

/**
 Position provider that delivered this position
 */
@property (nonatomic, weak, nullable) id<Optional> provider;

/**
 Get the probability of the position. This is a radius in meters. Can be used to generate an approximation circle.

 @return A double representing the positions accuracy in meters.
 */
- (double) getProbability;

/**
 Get the heading in degrees from north

 @return The heading value in degrees from north as a double
 */
- (double) getHeadingDegrees;

/**
 Get the floor index property

 @return The floor index
 */
- (nullable NSNumber*)getFloorIndex;

- (void) setProbability:(double)probability;
/**
 Set the heading of the position result in degrees from north
 
 @param heading The heading value in degrees from north as a double
 */
- (void) setHeadingDegrees:(double)heading;

@end
