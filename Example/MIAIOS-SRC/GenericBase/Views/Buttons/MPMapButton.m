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
#import "NSObject+ContentSizeChange.h"
#import "AppFonts.h"


@implementation MPMapButton

- (void) didMoveToSuperview {

    [super didMoveToSuperview];

    self.backgroundColor = [UIColor whiteColor];
    self.tintColor = [UIColor appAccentColor];
    self.titleLabel.tintColor = [UIColor appAccentColor];
    self.titleLabel.font = [AppFonts sharedInstance].buttonFont;
    self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    self.contentEdgeInsets = UIEdgeInsetsMake(4, 8, 4, 8);
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.cornerRadius = 4;
    self.layer.shadowRadius = 4;
    self.layer.shadowOpacity = 0.4;

    if (self.superview) {
        [self autoSetDimension:ALDimensionWidth toSize:120 relation:NSLayoutRelationGreaterThanOrEqual];
        [self autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.superview withMultiplier:0.9 relation:NSLayoutRelationLessThanOrEqual];
        [self autoSetDimension:ALDimensionHeight toSize:40 relation:NSLayoutRelationGreaterThanOrEqual];
        [self autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.superview withOffset:94];
    }

    __weak typeof(self)weakSelf = self;
    [self mp_onContentSizeChange:^(DynamicTextSize dynamicTextSize) {
        weakSelf.titleLabel.font = [AppFonts sharedInstance].buttonFont;
        [weakSelf setNeedsLayout];
    }];
}

@end
