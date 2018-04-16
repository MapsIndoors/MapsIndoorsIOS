//
//  SectionModel.m
//  MIAIOS
//
//  Created by Mobile Developer on 11/29/16.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import "SectionModel.h"


@implementation SectionModel

- (instancetype) initWithCurrentLeg:(MPRouteLeg *)leg
                       withLegIndex:(NSInteger )legIndex
                           withStep:(MPRouteStep *)step
                      withStepIndex:(NSInteger )stepIndex
                  withOptionVisible:(NSNumber *)isVisible
                          withItems:(NSMutableArray *)items
                        withDetails:(NSObject *)details
                     withTravelMode:(TRAVEL_MODE)travelMode
                        withLegType:(MPRouteLegType)legType
                          isOutside:(BOOL)isOutside
{
    self = [super init];
    if (self) {
        _leg = leg;
        _step = step;
        _isVisible = isVisible;
        _travelMode = travelMode;
        _legType = legType;
        _items = items;
        _details = details;
        _stepIndex = stepIndex;
        _legIndex = legIndex;
        _isOutside = isOutside;
    }
    return self;
}

@end
