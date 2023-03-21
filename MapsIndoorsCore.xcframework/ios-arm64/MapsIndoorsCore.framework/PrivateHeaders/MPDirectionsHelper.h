//
//  MPDirectionsHelper.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 23/04/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MPHighway;
@class MPRouteLegInternal;
@class MPRouteStepInternal;

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPDirectionsHelper : NSObject

+ (NSArray<MPHighway*>*) floorConnectors;
+ (void) generateLegAddresses:(MPRouteLegInternal*)routeLeg;
+ (int)getHeadingFactor:(double)headingDiff;
+ (NSString*) generateStepInstructions:(MPRouteStepInternal*)routeStep previousStep:(MPRouteStepInternal*)previousStep headingDiff: (double)headingDiff;
+ (NSString*) getManeuverWithHeadingDiff:(double)headingDiff;

@end

NS_ASSUME_NONNULL_END
