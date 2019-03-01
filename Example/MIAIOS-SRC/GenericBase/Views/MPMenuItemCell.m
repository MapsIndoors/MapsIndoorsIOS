//
//  MPLocationCell.m
//  MIAIOS
//
//  Created by Daniel Nielsen on 01/08/16.
//  Copyright © 2017-2018 MapsPeople. All rights reserved.
//

#import "MPMenuItemCell.h"
#import "NSObject+ContentSizeChange.h"
#import "AppFonts.h"


@interface MPMenuItemCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint*    spaceBetweenImageAndLabelConstraint;

@end


@implementation MPMenuItemCell

@synthesize imageView = _imageView;
@synthesize textLabel = _textLabel;

- (void)awakeFromNib {
    [super awakeFromNib];

    self.textLabel.font = AppFonts.sharedInstance.listItemFont;

    __weak typeof(self)weakSelf = self;
    [self mp_onContentSizeChange:^(DynamicTextSize dynamicTextSize) {
        weakSelf.textLabel.font = AppFonts.sharedInstance.listItemFont;
    }];
}

- (void) prepareForReuse {

    [super prepareForReuse];
    self.hideImage = NO;
}

- (void) setHideImage:(BOOL)hideImage {
    
    if ( self.imageView.hidden != hideImage ) {
        
        self.imageView.hidden = hideImage;
        
        if ( hideImage ) {
            self.spaceBetweenImageAndLabelConstraint.constant = - self.imageView.bounds.size.width;
        } else {
            self.spaceBetweenImageAndLabelConstraint.constant = 15;
        }
    }
}

@end
