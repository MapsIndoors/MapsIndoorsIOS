//
//  MPLocationCell.m
//  MIAIOS
//
//  Created by Daniel Nielsen on 01/08/16.
//  Copyright © 2017-2018 MapsPeople. All rights reserved.
//

#import "MPLocationCell.h"
#import "UIColor+AppColor.h"
@import VCMaterialDesignIcons;


@interface MPLocationCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textLabelVerticalOffsetConstraint;

@end


@implementation MPLocationCell

@synthesize imageView = _imageView;
@synthesize textLabel = _textLabel;
@synthesize subTextLabel = _subTextLabel;

- (void)didMoveToSuperview {
    _subTextLabel.font = [UIFont systemFontOfSize:14];
}

- (void) prepareForReuse {
    
    [super prepareForReuse];
    self.textLabelVerticalOffsetConstraint.constant = -8;
    self.subTextLabel.hidden = NO;
}

- (void) centerTextLabelVertically {
    
    self.textLabelVerticalOffsetConstraint.constant = 0;
    self.subTextLabel.hidden = YES;
}

@end
