//
//  UINavigationController+TransparentNavigationController.m
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 13/08/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import "UINavigationController+TransparentNavigationController.h"
#import "UIColor+AppColor.h"
@import VCMaterialDesignIcons;

@implementation UINavigationController (TransparentNavigationController)

- (void)awakeFromNib {
    self.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    
    UIView *statusBarBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -20, 1280, 20)];
    statusBarBackgroundView.tag = 909;
    statusBarBackgroundView.layer.opacity = 0.35;
    statusBarBackgroundView.backgroundColor = [UIColor appDarkPrimaryColor];
    
    [self.navigationBar addSubview:statusBarBackgroundView];

}

- (void)presentTransparentNavigationBar
{
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTranslucent:YES];
    [self.navigationBar setShadowImage:[UIImage new]];
    [self setNavigationBarHidden:NO animated:NO];

    //self.navigationBar.tintColor = [UIColor clearColor];
    
    UIImage* backImg = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_arrow_left fontSize:28.0f].image;
    self.navigationItem.leftBarButtonItem.image = backImg;
    
    UIView *statusBarBackgroundView = [self.navigationBar viewWithTag:909];
    statusBarBackgroundView.layer.opacity = 0.35;
    
}

- (void)resetNavigationBar
{
    [self.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTranslucent:YES];
    [self.navigationBar setShadowImage:nil];
    [self setNavigationBarHidden:NO animated:NO];
    
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.barTintColor = [UIColor appPrimaryColor];
    
    UIView *statusBarBackgroundView = [self.navigationBar viewWithTag:909];
    statusBarBackgroundView.layer.opacity = 0.35;
}

- (void)hideTransparentNavigationBar
{
    [self setNavigationBarHidden:YES animated:NO];
    [self.navigationBar setBackgroundImage:[[UINavigationBar appearance] backgroundImageForBarMetrics:UIBarMetricsDefault] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTranslucent:[[UINavigationBar appearance] isTranslucent]];
    [self.navigationBar setShadowImage:[[UINavigationBar appearance] shadowImage]];
    self.navigationBar.tintColor = [UIColor whiteColor];
    
    
    UIView *statusBarBackgroundView = [self.navigationBar viewWithTag:909];
    statusBarBackgroundView.layer.opacity = 0.35;
}

@end