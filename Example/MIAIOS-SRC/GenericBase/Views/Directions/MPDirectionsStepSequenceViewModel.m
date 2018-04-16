//
//  MPDirectionsStepSequenceViewModel.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 15/03/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import "MPDirectionsStepSequenceViewModel.h"
#import "MPDirectionsStepViewModel.h"
#import "NSString+Category.h"
#import "Global.h"


@interface MPDirectionsStepSequenceViewModel ()

@property (nonatomic, strong) NSArray<MPRouteStep*>*    steps;

@end


@implementation MPDirectionsStepSequenceViewModel

+ (instancetype) newWithSteps:(NSArray<MPRouteStep*>*)steps {
    return  [[MPDirectionsStepSequenceViewModel alloc] initWithSteps:steps];
}

- (instancetype) initWithSteps:(NSArray<MPRouteStep*>*)steps {

    self = [super init];
    if (self) {
        _steps = steps;
        _stepHeight = 66;
    }
    return self;
}

- (MPDirectionsStepViewModel*) modelForStepAtIndex:(NSUInteger)stepIndex {
   
    MPDirectionsStepViewModel*  model;
    
    if ( self.steps.count > stepIndex ) {
        
        MPRouteStep*    step = self.steps[ stepIndex ];
        NSString*       desc = NSLocalizedString([step.html_instructions stringByStrippingHTML],);
        NSString*       distance = [Global getDistanceString:[step.distance doubleValue]];
        BOOL            isStairs = [step.highway isEqualToString:@"steps"];
        model = [MPDirectionsStepViewModel newWithDescription:desc details:distance manuever:step.maneuver isStairs:isStairs];
    }
    
    return model;
}

- (NSUInteger) numberOfSteps {
    
    return self.steps.count;
}

- (CGFloat) totalHeight {
    
    return self.numberOfSteps * self.stepHeight;
}

@end
