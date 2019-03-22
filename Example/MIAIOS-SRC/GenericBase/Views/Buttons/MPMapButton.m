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


@interface MPMapButton ()

@property (nonatomic, weak) NSLayoutConstraint*     widthConstraint;
@end


@implementation MPMapButton

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    self.backgroundColor = [UIColor whiteColor];
    self.tintColor = [UIColor appAccentColor];
    self.titleLabel.tintColor = [UIColor appAccentColor];
    self.titleLabel.font = [AppFonts sharedInstance].buttonFont;
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = CGSizeMake(0, 2);
    self.layer.shadowRadius = 4;
    self.layer.shadowOpacity = 0.5;
    [self sizeToFit];
    
    if (self.superview) {
        CGFloat w = self.bounds.size.width +16;
        self.widthConstraint = [self autoSetDimension:ALDimensionWidth toSize:w relation:NSLayoutRelationGreaterThanOrEqual];
        [self autoSetDimension:ALDimensionHeight toSize:40 relation:NSLayoutRelationGreaterThanOrEqual];
        [self autoAlignAxisToSuperviewAxis:ALAxisVertical];
        [self autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.superview withOffset:94];
    }

    [self mp_onContentSizeChange:^(DynamicTextSize dynamicTextSize) {
        self.titleLabel.font = [AppFonts sharedInstance].buttonFont;
        [self sizeToFit];
        CGFloat w = self.bounds.size.width +16;
        self.widthConstraint.constant = w;
    }];
}

@end
