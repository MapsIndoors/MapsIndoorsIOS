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

    self.searchBarStyle = UISearchBarStyleProminent;
    self.barTintColor = [UIColor appPrimaryColor];
    self.translucent = NO;
    self.showsCancelButton = NO;
    self.barStyle = UIBarStyleDefault;
    self.tintColor = [UIColor darkGrayColor];
    self.returnKeyType = UIReturnKeyGo;

    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTintColor:[UIColor whiteColor]];

    if ( @available(iOS 13, *) ) {
        self.searchTextField.backgroundColor = [UIColor whiteColor];
        self.searchTextField.textColor = [UIColor darkGrayColor];
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
