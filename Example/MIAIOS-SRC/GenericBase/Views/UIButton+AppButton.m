//
//  UIButton+AppButton.m
//  MIAIOS
//
//  Created by Daniel Nielsen on 26/08/15.
//  Copyright (c) 2015-2018 MapsPeople A/S. All rights reserved.
//
#import "UIButton+AppButton.h"
#import "UIColor+AppColor.h"
#import "NSObject+ContentSizeChange.h"
#import "AppFonts.h"


@implementation UIButton (AppButton)

+ (UIButton *)appRectButtonWithTitle: (NSString*)title target: (id)target selector:(SEL)selector {

    return [self appRectButtonWithTitle:title target:target selector:selector xOffset:0];
}

+ (UIButton *)appRectButtonWithTitle: (NSString*)title target: (id)target selector:(SEL)selector xOffset:(int)x {

    UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(x, 0, 106, 40)];
    btn.backgroundColor = [UIColor appAccentColor];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [AppFonts sharedInstance].buttonFont;
    btn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];

    __weak typeof(btn)weakBtn = btn;
    [weakBtn mp_onContentSizeChange:^(DynamicTextSize dynamicTextSize) {
        weakBtn.titleLabel.font = [AppFonts sharedInstance].buttonFont;
    }];

    return btn;
}

@end
