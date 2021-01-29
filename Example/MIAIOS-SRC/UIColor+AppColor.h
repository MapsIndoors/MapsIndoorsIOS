//
//  AppColor.h
//  MIAIOS
//
//  Created by Daniel Nielsen on 26/08/15.
//  Copyright (c) 2015-2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (AppColors)

+ (UIColor*) colorFromRGBA:(NSString *)rgba;

+ (UIColor *)appPrimaryColor;
+ (UIColor *)appDarkPrimaryColor;
+ (UIColor *)appLightPrimaryColor;
+ (UIColor *)appTextAndIconColor;
+ (UIColor *)appPrimaryTextColor;
+ (UIColor *)appSecondaryTextColor;
+ (UIColor *)appAccentColor;
+ (UIColor *)appDividerColor;
+ (UIColor *)appLaunchScreenColor;
+ (UIColor *)appStatusBarColor;
+ (UIColor *)appTertiaryHighlightColor;
+ (UIColor *)appRouteHighlightColor;
+ (UIColor *)appToastBackgroundColor;

@end
