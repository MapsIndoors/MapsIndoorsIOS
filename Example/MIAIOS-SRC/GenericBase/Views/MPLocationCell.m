//
//  MPLocationCell.m
//  MIAIOS
//
//  Created by Daniel Nielsen on 01/08/16.
//  Copyright © 2017-2018 MapsPeople. All rights reserved.
//

#import "MPLocationCell.h"
#import "NSObject+ContentSizeChange.h"
#import "AppFonts.h"


@implementation MPLocationCell

@synthesize imageView = _imageView;
@synthesize textLabel = _textLabel;
@synthesize subTextLabel = _subTextLabel;

- (void) awakeFromNib {

    [super awakeFromNib];

    self.textLabel.font = [AppFonts sharedInstance].listItemFont;
    self.subTextLabel.font = [AppFonts sharedInstance].listItemSubTextFont;

    [self mp_onContentSizeChange:^(DynamicTextSize dynamicTextSize) {
        self.textLabel.font = [AppFonts sharedInstance].listItemFont;
        self.subTextLabel.font = [AppFonts sharedInstance].listItemSubTextFont;
    }];
}

- (void) prepareForReuse {
    
    [super prepareForReuse];
    self.subTextLabel.hidden = NO;
}

- (void) centerTextLabelVertically {
    
    self.subTextLabel.hidden = YES;
}

@end
