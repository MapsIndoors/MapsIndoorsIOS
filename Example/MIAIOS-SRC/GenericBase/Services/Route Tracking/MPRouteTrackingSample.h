//
//  MPRouteTrackingSample.h
//  MapsIndoors App
//
//  Created by Michael Bech Hansen on 20/03/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@class MPPoint;
@class MPPositionResult;


NS_ASSUME_NONNULL_BEGIN

@interface MPRouteTrackingSample : NSObject

/**
 Timestamp this sample was created
 */
@property (nonatomic, strong, readonly, nullable) NSDate*       timestamp;
@property (nonatomic, readonly) NSTimeInterval                  age;

/**
 Position (lat, long) of the sample
 */
@property (nonatomic, strong, readonly, nullable) MPPoint*      geometry;

/**
 Floor level of the sample
 */
@property (nonatomic, strong, readonly, nullable) NSNumber*     floor;

/**
 Heading of the sample.
 */
@property (nonatomic, strong, readonly, nullable) NSNumber*     heading;

/**
 Accuracy of the sample (small is better than large number)
 */
@property (nonatomic, strong, readonly, nullable) NSNumber*     accuracy;


+ (instancetype) newWithPosition:(MPPositionResult*)positionResult;
- (instancetype) initWithPosition:(MPPositionResult*)positionResult;
- (instancetype) init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
