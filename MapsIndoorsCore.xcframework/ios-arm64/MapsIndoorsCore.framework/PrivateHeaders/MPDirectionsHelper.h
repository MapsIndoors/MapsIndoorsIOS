//
//  MPDirectionsHelper.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 23/04/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MPRouteLeg;
@class MPRouteStep;

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPDirectionsHelper : NSObject

+ (NSArray<NSString*>*) floorConnectors;
+ (void) generateLegAddresses:(MPRouteLeg*)routeLeg;
+ (int)getHeadingFactor:(double)headingDiff;
+ (NSString*) generateStepInstructions:(MPRouteStep*)routeStep previousStep:(MPRouteStep*)previousStep headingDiff: (double)headingDiff;
+ (NSString*) getManeuverWithHeadingDiff:(double)headingDiff;

@end

NS_ASSUME_NONNULL_END
