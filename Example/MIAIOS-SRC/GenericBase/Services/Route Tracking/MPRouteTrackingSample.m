//
//  MPRouteTrackingSample.m
//  MapsIndoors App
//
//  Created by Michael Bech Hansen on 20/03/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//

#import "MPRouteTrackingSample.h"
#import <MapsIndoors/MapsIndoors.h>


@interface MPRouteTrackingSample ()

@property (nonatomic, strong, readwrite, nullable) NSDate*      timestamp;
@property (nonatomic, strong, readwrite, nullable) MPPoint*     geometry;
@property (nonatomic, strong, readwrite, nullable) NSNumber*    heading;
@property (nonatomic, strong, readwrite, nullable) NSNumber*    accuracy;

@end

@implementation MPRouteTrackingSample

+ (instancetype) newWithPosition:(MPPositionResult*)positionResult {

    return [[MPRouteTrackingSample alloc] initWithPosition:positionResult];
}

- (instancetype) initWithPosition:(MPPositionResult*)positionResult {

    self = [super init];
    if (self) {
        _timestamp = [NSDate date];

        if ( positionResult ) {
            _geometry = [positionResult.geometry copy];
            _floor = [positionResult getFloor];
            if ( positionResult.headingAvailable ) {
                _heading = @([positionResult getHeadingDegrees]);
            }
            _accuracy = @([positionResult getProbability]);
        }
    }

    return self;
}

- (NSTimeInterval) age {

    return - [self.timestamp timeIntervalSinceNow];
}

- (NSString*) debugDescription {

    return [NSString stringWithFormat:@"<MPRouteTrackingSample %p: %@, heading=%@, accuracy=%@, dt=%.02f, %@>", self, self.geometry.latLngString, self.heading, self.accuracy, self.age, self.timestamp];
}


@end
