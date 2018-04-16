//
//  MPDirectionsStepSequenceView.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 15/03/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MPDirectionsStepSequenceViewModel;


@interface MPDirectionsStepSequenceView : UIView

@property (nonatomic, strong) MPDirectionsStepSequenceViewModel*    viewModel;
@property (nonatomic) CGFloat                                       stepHeight;         // default 56

@end
