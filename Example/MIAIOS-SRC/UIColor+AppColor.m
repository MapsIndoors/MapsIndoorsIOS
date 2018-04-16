//
//  AppColor.m
//  MIAIOS
//
//  Created by Daniel Nielsen on 26/08/15.
//  Copyright (c) 2015-2018 MapsPeople A/S. All rights reserved.
//

#import "UIColor+AppColor.h"
#import "Global.h"
#import <MapsIndoors/MapsIndoors.h>

@implementation UIColor (AppColors)

+ (UIColor*) colorFromRGBA:(NSString *)rgba {
    
    float red = 0.0;
    float green = 0.0;
    float blue = 0.0;
    float alpha = 1.0;
    
    if ([rgba hasPrefix:@"#"]) {
        NSString *hex = [rgba substringFromIndex:1];
        NSScanner *scanner = [NSScanner scannerWithString:hex];
        unsigned long long hexValue = 0;
        if ([scanner scanHexLongLong:&hexValue]) {
            switch (hex.length) {
                case 3:
                    red = ((hexValue & 0xF00) >> 8) / 15.0;
                    green = ((hexValue & 0x0F0) >> 4) / 15.0;
                    blue = (hexValue & 0x00F) / 15.0;
                    break;
                case 4:
                    red = ((hexValue & 0xF000) >> 12) / 15.0;
                    green = ((hexValue & 0x0F00) >> 8) / 15.0;
                    blue = ((hexValue & 0x00F0) >> 4) / 15.0;
                    alpha = (hexValue & 0x000F) / 15.0;
                    break;
                case 6:
                    red = ((hexValue & 0xFF0000) >> 16) / 255.0;
                    green = ((hexValue & 0x00FF00) >> 8) / 255.0;
                    blue = (hexValue & 0x0000FF) / 255.0;
                    break;
                case 8:
                    red = ((hexValue & 0xFF000000) >> 24) / 255.0;
                    green = ((hexValue & 0x00FF0000) >> 16) / 255.0;
                    blue = ((hexValue & 0x0000FF00) >> 8) / 255.0;
                    alpha = (hexValue & 0x000000FF) / 255.0;
                    break;
                default:
                    NSLog( @"Invalid RGB string: '%@', number of characters after '#' should be either 3, 4, 6 or 8", rgba );
            }
        } else {
            NSLog(@"Scan hex error");
        }
    } else {
        NSLog(@"Invalid RGB string: '%@', missing '#' as prefix", rgba);
    }
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)appPrimaryColor {
    return [UIColor colorFromRGBA:[Global getPropertyFromPlist:@"PrimaryColor"]];
}

+ (UIColor *)appLaunchScreenColor {
    NSString *c = [Global getPropertyFromPlist:@"LaunchScreenColor"];
    if (c) return [UIColor colorFromRGBA:c];
    return [UIColor appPrimaryColor];
}

+ (UIColor *)appDarkPrimaryColor {
    return [UIColor colorFromRGBA:[Global getPropertyFromPlist:@"DarkPrimaryColor"]];
}

+ (UIColor *)appLightPrimaryColor {
    return [UIColor colorFromRGBA:[Global getPropertyFromPlist:@"LightPrimaryColor"]];
}

+ (UIColor *)appTextAndIconColor {
    return [UIColor colorFromRGBA:@"#efefef"];
}

+ (UIColor *)appPrimaryTextColor {
    return [UIColor colorFromRGBA:@"#666666"];
}

+ (UIColor *)appSecondaryTextColor {
    return [UIColor colorFromRGBA:@"#727272"];
}

+ (UIColor *)appAccentColor {
    return [UIColor colorFromRGBA:[Global getPropertyFromPlist:@"AccentColor"]];
}

+ (UIColor *)appDividerColor {
    return [UIColor colorFromRGBA:@"#B6B6B6"];
}

+ (UIColor *)appStatusBarColor {
    NSString*   c = [Global getPropertyFromPlist:@"StatusBarColor"];
    return (c.length != 0) ? [UIColor colorFromRGBA:c] : [UIColor appDarkPrimaryColor];
}

+ (UIColor *)appTertiaryHighlightColor {
    NSString*   c = [Global getPropertyFromPlist:@"TertiaryHighlightColor"] ?: @"#43aaa0";
    return (c.length != 0) ? [UIColor colorFromRGBA:c] : [UIColor appPrimaryColor];
}

+ (UIColor*) appToastBackgroundColor {
    return [UIColor colorFromRGBA:@"#323232EE"];
}

@end
