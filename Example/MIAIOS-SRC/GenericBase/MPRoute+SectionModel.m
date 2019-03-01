//
//  MPRoute+SectionModel.m
//  MapsIndoors App
//
//  Created by Michael Bech Hansen on 27/06/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "MPRoute+SectionModel.h"
#import "SectionModel.h"


@implementation MPRoute (SectionModel)

- (NSArray<SectionModel*>*) sectionModelsForRequestTravelMode:(TRAVEL_MODE)requestTravelMode {
    
    NSMutableArray* modelArray = [NSMutableArray array];
    
    for (int j = 0; j < self.legs.count; j++)
    {
        MPRouteLeg*     leg = [self.legs objectAtIndex:j]; //Map route legs
        MPRouteLegType  legType = leg.routeLegType;
        
        NSMutableArray* substeps = leg.steps;
        
        for (int i = 0; i < leg.steps.count; i++) {
            
            MPRouteStep *step = [leg.steps objectAtIndex:i];
            
            BOOL isOutside = step.routeContext == nil || [step.routeContext isEqual:@"OutsideOnVenue"];
            BOOL useSubsteps = YES;
            
            if ( !isOutside || (isOutside && (requestTravelMode != TRANSIT) && (legType != MPRouteLegTypeMapsIndoors)) ) {
                useSubsteps = NO;
                substeps = nil;
            }
            
            MPRouteStep* stepToUse = step;
            if ( (isOutside == NO) || ((requestTravelMode != TRANSIT) && (legType != MPRouteLegTypeMapsIndoors)) || (isOutside  && (legType == MPRouteLegTypeMapsIndoors))) {
                stepToUse = nil;
            }
            
            SectionModel *model = [[SectionModel alloc] initWithCurrentLeg:leg
                                                              withLegIndex:j
                                                                  withStep:stepToUse
                                                             withStepIndex:stepToUse ? i : -1
                                                         withOptionVisible:@(NO)
                                                                 withItems:substeps
                                                               withDetails:nil
                                                            withTravelMode:requestTravelMode
                                                               withLegType:legType
                                                                 isOutside:isOutside];
            
            [modelArray addObject:model];
            
            if ( !useSubsteps || (legType == MPRouteLegTypeMapsIndoors) ) {
                break;
            }
        }
    }
    
    return [modelArray copy];
}

@end
