//
//  MPPositionResult.h
//  MapsIndoorSDK
//
//  Created by Daniel Nielsen on 10/03/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPPoint.h"
#import <JSONModel/JSONModel+networking.h>

@interface MPPositionResult : JSONModel

@property MPPoint* geometry;
@property NSMutableDictionary* properties;
@property NSString* type;
@property id<Optional> provider;

- (double)getProbability;
- (double)getRoundtrip;
- (double)getHeadingDegrees;
- (NSNumber*)getAge;
- (NSNumber*)getFloor;

- (void)setProbability:(double)probability;
- (void)setHeadingDegrees:(double)heading;

@end
