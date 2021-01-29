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
    self.lowerLeftBadgeLabel.backgroundColor = UIColor.clearColor;
    self.lowerLeftBadgeLabel.text = @"";

    __weak typeof(self)weakSelf = self;
    [self mp_onContentSizeChange:^(DynamicTextSize dynamicTextSize) {
        weakSelf.textLabel.font = [AppFonts sharedInstance].listItemFont;
        weakSelf.subTextLabel.font = [AppFonts sharedInstance].listItemSubTextFont;
    }];
}

- (void) prepareForReuse {
    
    [super prepareForReuse];
    self.subTextLabel.hidden = NO;
    self.accessoryView = nil;
    self.lowerLeftBadgeLabel.backgroundColor = UIColor.clearColor;
    self.lowerLeftBadgeLabel.text = @"";
}

- (void) centerTextLabelVertically {
    
    self.subTextLabel.hidden = YES;
}

- (void) setBadgeColor:(UIColor*)c andText:(NSString*)s {

    self.lowerLeftBadgeLabel.backgroundColor = c;
    self.lowerLeftBadgeLabel.text = s;
    [self.lowerLeftBadgeLabel setFont:[UIFont boldSystemFontOfSize:12]];
    self.lowerLeftBadgeLabel.layer.masksToBounds = YES;
    self.lowerLeftBadgeLabel.layer.cornerRadius = self.lowerLeftBadgeLabel.bounds.size.width / 2;
}

@end
