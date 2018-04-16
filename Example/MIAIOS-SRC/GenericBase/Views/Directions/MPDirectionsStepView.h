//
//  MPDirectionsStepView.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 15/03/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MPDirectionsStepViewModel;


@interface MPDirectionsStepView : UIView

@property (nonatomic, weak, readonly) UIImageView*      manueverImageView;
@property (nonatomic, weak, readonly) UILabel*          textLabel;

- (void) configureWithModel:(MPDirectionsStepViewModel*)model;
- (void) configureWithDescription:(NSString*)desc detail:(NSString*)detail manuever:(NSString*)manuever isStairs:(BOOL)isStairs;

@end
