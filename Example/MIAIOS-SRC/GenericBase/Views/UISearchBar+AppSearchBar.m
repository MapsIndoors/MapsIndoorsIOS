//
//  UISearchBar+AppSearchBar.m
//  MIAIOS
//
//  Created by Daniel Nielsen on 31/08/15.
//  Copyright (c) 2015-2018 MapsPeople A/S. All rights reserved.
//

#import "UISearchBar+AppSearchBar.h"
#import "UIColor+AppColor.h"
@import VCMaterialDesignIcons;

@implementation UISearchBar (AppSearchBar)

- (void) awakeFromNib {
    
    [super awakeFromNib];
    [self setCustomStyle];
}

- (void) setCustomStyle {
    
    self.searchBarStyle = UISearchBarStyleMinimal;
    
    [self setBackgroundImage:[self imageWithBackgroundColor:[UIColor appPrimaryColor] statusBarColor:[UIColor appDarkPrimaryColor]]
              forBarPosition:UIBarPositionTopAttached
                  barMetrics:UIBarMetricsDefault];
    [self setBackgroundImage:[self imageWithBackgroundColor:[UIColor appPrimaryColor] statusBarColor:nil]
              forBarPosition:UIBarPositionTop
                  barMetrics:UIBarMetricsDefault];
    
    self.tintColor = [UIColor whiteColor];
    
    VCMaterialDesignIcons *icon = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_search fontSize:20.f];
    [icon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    [self setImage: icon.image forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];

    self.placeholder = @"";
    
    self.showsCancelButton = NO;
    
    UITextField *searchField = [self valueForKey:@"_searchField"];
    searchField.textColor = [UIColor whiteColor];
    
    UIImage *imgClear = [UIImage imageNamed:@"clear"];
    [self setImage:imgClear forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    
}

- (void) setPlaceholder:(NSString *)placeholder {
    
    UITextField *searchTextField = [self valueForKey:@"_searchField"];
    if ([searchTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor whiteColor];
        [searchTextField setAttributedPlaceholder:[[NSAttributedString alloc] initWithString:placeholder attributes:@{NSForegroundColorAttributeName: color}]];
    }
}

- (UIImage*) imageWithBackgroundColor:(UIColor *)backgroundColor statusBarColor:(UIColor *)statusBarColor {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 320.0f, 64.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect searchBarRect = CGRectMake(0.0f, 0.0f, 320.0f, 64.0f);
    CGContextSetFillColorWithColor(context, [backgroundColor CGColor]);
    CGContextFillRect(context, searchBarRect);
    
    if (statusBarColor) {
        CGRect statusBarRect = CGRectMake(0.0f, 0.0f, 320.0f, 20.0f);
        
        CGContextSetFillColorWithColor(context, [statusBarColor CGColor]);
        CGContextFillRect(context, statusBarRect);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
