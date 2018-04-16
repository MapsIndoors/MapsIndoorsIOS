//
//  MPDirectionsStepSequenceViewModel.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 15/03/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapsIndoors/MapsIndoors.h>

@class MPDirectionsStepViewModel;


@interface MPDirectionsStepSequenceViewModel : NSObject

@property (nonatomic, readonly) NSUInteger      numberOfSteps;
@property (nonatomic) CGFloat                   stepHeight;         // default 66
@property (nonatomic, readonly) CGFloat         totalHeight;

+ (instancetype) newWithSteps:(NSArray<MPRouteStep*>*)steps;
- (instancetype) initWithSteps:(NSArray<MPRouteStep*>*)steps;
- (instancetype) init NS_UNAVAILABLE;

- (MPDirectionsStepViewModel*) modelForStepAtIndex:(NSUInteger)stepIndex;

@end
