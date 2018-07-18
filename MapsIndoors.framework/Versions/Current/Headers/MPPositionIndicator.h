//
//  MPPositionIndicator.h
//  MapsIndoors
//
//  Created by Martin Hansen on 5/20/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import "MPLocation.h"


@interface MPPositionIndicator : MPLocation

@property (nonatomic) double probability;
@property (nonatomic) double bearing;
@property (nonatomic) CLLocationCoordinate2D position;
@property (nonatomic) bool showProbability;

- (nullable instancetype) initWithPoint:(nullable MPPoint *)point andName:(nullable NSString *)name;
- (void) updateView:(nonnull GMSMapView *)map floor:(int)floor displayRules:(nonnull MPLocationDisplayRuleset *)displayRuleset;

@end
	
