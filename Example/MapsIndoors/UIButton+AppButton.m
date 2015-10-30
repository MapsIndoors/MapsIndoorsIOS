//
//  AppColor.m
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 26/08/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//
#import "UIButton+AppButton.h"
#import "UIColor+AppColor.h"
#import <MapsIndoorsSDK/UIColor+HexString.h>
#import <MaterialControls/MDButton.h>

@implementation UIButton (AppButton)

+ (MDButton *)appRectButtonWithTitle: (NSString*)title target: (id)target selector:(SEL)selector
{
    return [self appRectButtonWithTitle:title target:target selector:selector xOffset:0];
}

+ (MDButton *)appRectButtonWithTitle: (NSString*)title target: (id)target selector:(SEL)selector xOffset:(int)x {
    MDButton* btn = [[MDButton alloc] initWithFrame:CGRectMake(x, 0, 120, 40) type:Raised rippleColor:[UIColor colorWithWhite:1 alpha:0.2f]];
    btn.backgroundColor = [UIColor appAccentColor];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    [btn addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

@end
