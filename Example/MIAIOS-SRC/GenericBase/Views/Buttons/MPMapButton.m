//
//  MPMapButton.m
//  MIAIOS
//
//  Created by Daniel Nielsen on 16/11/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import "MPMapButton.h"
#import "UIColor+AppColor.h"
#import <PureLayout/PureLayout.h>

@implementation MPMapButton

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    self.backgroundColor = [UIColor whiteColor];
    self.tintColor = [UIColor appAccentColor];
    self.titleLabel.tintColor = [UIColor appAccentColor];
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowRadius = 4;
    self.layer.shadowOpacity = 0.5;
    
    if (self.superview) {
        [self autoSetDimensionsToSize:CGSizeMake(200, 40)];
        [self autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.superview withOffset:94];
    }
}

@end
