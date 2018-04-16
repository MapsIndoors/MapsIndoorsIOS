//
//  SectionModel.h
//  MIAIOS
//
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapsIndoors/MapsIndoors.h>
#import "Global.h"      // TRAVEL_MODE

@interface SectionModel : NSObject

@property (nonatomic, copy, readonly) NSDictionary *distanceDict;
@property (nonatomic, copy, readonly) NSDictionary *durationDict;
@property (nonatomic, strong, readonly) MPRouteLeg *leg;
@property (nonatomic, assign, readonly) NSInteger legIndex;
@property (nonatomic, strong, readonly) MPRouteStep *step;
@property (nonatomic, assign, readonly) NSInteger stepIndex;
@property (nonatomic, strong, readonly) NSNumber *isVisible;
@property (nonatomic, strong, readonly) NSArray *items;
@property (nonatomic, strong, readonly) NSObject *details;
@property (nonatomic, assign, readonly) TRAVEL_MODE travelMode;
@property (nonatomic, assign, readonly) MPRouteLegType legType;
@property (nonatomic, assign, readonly) BOOL isOutside;

-(instancetype)initWithCurrentLeg:(MPRouteLeg *)leg
                     withLegIndex:(NSInteger )legIndex
                         withStep:(MPRouteStep *)step
                    withStepIndex:(NSInteger )stepIndex
                withOptionVisible:(NSNumber *)isVisible
                        withItems:(NSMutableArray *)items
                      withDetails:(NSObject *)details
                   withTravelMode:(TRAVEL_MODE)travelMode
                      withLegType:(MPRouteLegType)legType
                        isOutside:(BOOL)isOutside;


@end
