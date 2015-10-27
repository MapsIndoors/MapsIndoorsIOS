//
//  AppColor.m
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 26/08/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import "UIColor+AppColor.h"
#import <MapsIndoorSDK/UIColor+HexString.h>

@implementation UIColor (AppColors)

+ (UIColor *)appPrimaryColor
{
    return [UIColor colorFromHexString:@"#2196F3"];
}
+ (UIColor *)appDarkPrimaryColor
{
    return [UIColor colorFromHexString:@"#1976D2"];
}
+ (UIColor *)appLightPrimaryColor
{
    return [UIColor colorFromHexString:@"#BBDEFB"];
}
+ (UIColor *)appTextAndIconColor
{
    return [UIColor colorFromHexString:@"#efefef"];
}
+ (UIColor *)appPrimaryTextColor
{
    return [UIColor colorFromHexString:@"#212121"];
}
+ (UIColor *)appSecondaryTextColor
{
    return [UIColor colorFromHexString:@"#727272"];
}
+ (UIColor *)appAccentColor
{
    return [UIColor colorFromHexString:@"#FF5722"];
}
+ (UIColor *)appDividerColor
{
    return [UIColor colorFromHexString:@"#B6B6B6"];
}

@end
