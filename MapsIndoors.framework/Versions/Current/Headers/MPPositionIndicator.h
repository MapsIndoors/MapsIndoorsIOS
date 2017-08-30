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
@property (nonatomic,retain) GMSMapView* map;
@property (nonatomic) bool showProbability;

- (id)initWithPoint:(MPPoint *)point andName:(NSString *)name;
- (void)updateView:(GMSMapView *)map floor:(int)floor displayRules:(MPLocationDisplayRuleset *)displayRuleset;
@end
	