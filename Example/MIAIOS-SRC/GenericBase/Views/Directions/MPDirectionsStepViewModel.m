//
//  MPDirectionsStepViewModel.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 15/03/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import "MPDirectionsStepViewModel.h"


@implementation MPDirectionsStepViewModel

+ (instancetype) newWithDescription:(NSString*)desc details:(NSString*)details manuever:(NSString*)manuever isStairs:(BOOL)isStairs {
    
    return [[MPDirectionsStepViewModel alloc] initWithDescription:desc details:details manuever:manuever isStairs:isStairs];
}

- (instancetype) initWithDescription:(NSString*)desc details:(NSString*)details manuever:(NSString*)manuever isStairs:(BOOL)isStairs {
    
    self = [super init];
    if (self) {
        _stepDescription = desc;
        _stepDetail = details;
        _stepManuever = manuever;
        _isStairs = isStairs;
    }
    return self;
}

@end
