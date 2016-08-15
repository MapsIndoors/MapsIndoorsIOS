//
//  FloatingActionMenuController.m
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 08/09/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import "FloatingActionMenuController.h"
#import "UIColor+AppColor.h"
#import "LocalizationSystem.h"
#import "LocalizedStrings.h"
#import "Global.h"
@import VCMaterialDesignIcons;
@import AFNetworking;


@interface FloatingActionMenuController ()

@end

@implementation FloatingActionMenuController {
    
    MPAppDataProvider* _appDataProvider;
    MDSnackbar* _bar;
    
    NSMutableArray* _menuItemModels;
    NSArray* _menuItems;
    NSArray* _menuItemsTop;
    UIView* _menuOpenContainerView;
    UIImageView* _menuOpenBtnImageView;
    UIImage* _menuCloseImage;
    UIImage* _menuOpenImage;
    int _initTop;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeFloatingActionMenu) name:@"MenuOpenedOrClosed" object:nil];
    _appDataProvider = [[MPAppDataProvider alloc] init];
    [_appDataProvider getAppDataAsync:Global.solutionId language:LocalizationGetLanguage completionHandler:^(MPAppData *appData, NSError *error) {
        if (error && !_bar.isShowing) {
            _bar = [[MDSnackbar alloc] initWithText:kLangCouldNotFindContent actionTitle:@"" duration:4.0];
            [_bar show];
        }
        else if (appData) {
            _menuItemModels = [NSMutableArray array];
            for (NSDictionary* item in [appData.menuInfo objectForKey:@"fabmenu"]) {
                NSError* err;
                MPMenuItem* menuItem = [[MPMenuItem alloc] initWithDictionary:item error:&err];
                if (err == nil)
                    [_menuItemModels addObject:menuItem];
            }
            [self setupFloatingActionBtn];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    //[self setupFloatingActionBtn];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) setupFloatingActionBtn {
    _menuOpenContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    UIView* itemsView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 40, 240)];
    _menuItemsTop = @[@120, @60, @0];
    _initTop = 180;
    MDButton *btn1 = [[MDButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40) type:MDButtonTypeFloatingAction rippleColor:[UIColor appLightPrimaryColor]];
    btn1.tag = 0;
    [btn1 addTarget:self action:@selector(getNearest:) forControlEvents:UIControlEventTouchDown];
    MDButton *btn2 = [[MDButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40) type:MDButtonTypeFloatingAction rippleColor:[UIColor appLightPrimaryColor]];
    btn2.tag = 1;
    [btn2 addTarget:self action:@selector(getNearest:) forControlEvents:UIControlEventTouchDown];
    MDButton *btn3 = [[MDButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40) type:MDButtonTypeFloatingAction rippleColor:[UIColor appLightPrimaryColor]];
    btn3.tag = 2;
    [btn3 addTarget:self action:@selector(getNearest:) forControlEvents:UIControlEventTouchDown];
    MDButton *nearestBtn = [[MDButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60) type:MDButtonTypeFloatingAction rippleColor:[UIColor colorWithWhite:255 alpha:.2f]];
    
    btn1.backgroundColor = [UIColor whiteColor];
    btn2.backgroundColor = [UIColor whiteColor];
    btn3.backgroundColor = [UIColor whiteColor];
    nearestBtn.backgroundColor = [UIColor appAccentColor];
    
    //Image icons or fonts?
    
    VCMaterialDesignIcons* icon = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_search fontSize:30];
    [icon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    _menuOpenImage = [UIImage imageNamed:@"Findnearest"];;
    
    VCMaterialDesignIcons* iconClose = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_close fontSize:30];
    [iconClose addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    _menuCloseImage = iconClose.image;
    
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:nearestBtn.frame];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = _menuOpenImage;
    [nearestBtn addSubview:imageView];
    [nearestBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [nearestBtn setTitle:[kLangFind_nearest uppercaseString] forState:UIControlStateNormal];
    [nearestBtn setTitleEdgeInsets:UIEdgeInsetsMake(3.0f, -190.0f, 0.0f, 20.0f)];
    
    MPMenuItem* item1 = [_menuItemModels objectAtIndex:0];
    
    UIImageView* imageView1 = [[UIImageView alloc] initWithFrame:btn1.frame];
    imageView1.contentMode = UIViewContentModeCenter;
    [imageView1 setImageWithURL:[NSURL URLWithString: item1.iconUrl]];
//    imageView1.image = [imageView1.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    imageView1.tintColor = [UIColor appSecondaryTextColor];
    [btn1 addSubview:imageView1];
    
    MPMenuItem* item2 = [_menuItemModels objectAtIndex:1];
    
    UIImageView* imageView2 = [[UIImageView alloc] initWithFrame:btn2.frame];
    imageView2.contentMode = UIViewContentModeCenter;
    [imageView2 setImageWithURL:[NSURL URLWithString: item2.iconUrl]];
//    imageView2.image = [imageView2.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    imageView2.tintColor = [UIColor appSecondaryTextColor];
    [btn2 addSubview:imageView2];
    
    MPMenuItem* item3 = [_menuItemModels objectAtIndex:2];
    
    UIImageView* imageView3 = [[UIImageView alloc] initWithFrame:btn3.frame];
    imageView3.contentMode = UIViewContentModeCenter;
    [imageView3 setImageWithURL:[NSURL URLWithString: item3.iconUrl]];
//    imageView3.image = [imageView3.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//    imageView3.tintColor = [UIColor appSecondaryTextColor];
    [btn3 addSubview:imageView3];
    
    _menuOpenBtnImageView = imageView;
    
    _menuItems = @[btn1, btn2, btn3];
    
    
    [_menuOpenContainerView addSubview:nearestBtn];
    [itemsView addSubview:btn1];
    [itemsView addSubview:btn2];
    [itemsView addSubview:btn3];
    
    [self.view addSubview:itemsView];
    [self.view addSubview:_menuOpenContainerView];
    
    [nearestBtn addTarget:self action:@selector(toggleFloatingActionMenu:) forControlEvents:UIControlEventTouchDown];
    
}

- (void) toggleFloatingActionMenu:(id)sender {
    _initTop = _initTop * -1;
    [UIView animateWithDuration:.3 animations:^{
        
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + _initTop, self.view.frame.size.width, self.view.frame.size.height - _initTop);
        _menuOpenContainerView.frame = CGRectMake(0, _menuOpenContainerView.frame.origin.y - _initTop, _menuOpenContainerView.frame.size.width, _menuOpenContainerView.frame.size.height);
        
        for (int i = 0; i < _menuItems.count; i++) {
            MDButton* btn = (MDButton*)[_menuItems objectAtIndex:i];
            if (btn.frame.origin.y == 0) {
                btn.frame = CGRectMake(btn.frame.origin.x, [[_menuItemsTop objectAtIndex:i] intValue], btn.frame.size.width, btn.frame.size.height);
            } else {
                btn.frame = CGRectMake(btn.frame.origin.x, 0, btn.frame.size.width, btn.frame.size.height);
            }
        }
    }];
    
    CGAffineTransform rotationTransform = CGAffineTransformIdentity;
    rotationTransform = CGAffineTransformRotate(rotationTransform, 0);
    _menuOpenBtnImageView.transform = rotationTransform;
    
    [UIView animateWithDuration:0.15 animations:^{
        CGAffineTransform rotationTransform = CGAffineTransformIdentity;
        rotationTransform = CGAffineTransformRotate(rotationTransform, 3.14f);
        _menuOpenBtnImageView.transform = rotationTransform;
    } completion:^(BOOL finished) {
        if (_menuOpenBtnImageView.image == _menuOpenImage) {
            _menuOpenBtnImageView.image = _menuCloseImage;
        } else {
            _menuOpenBtnImageView.image = _menuOpenImage;
        }
        [UIView animateWithDuration:0.15 animations:^{
            CGAffineTransform rotationTransform = CGAffineTransformIdentity;
            rotationTransform = CGAffineTransformRotate(rotationTransform, 6.28f);
            _menuOpenBtnImageView.transform = rotationTransform;
        }];
    }];
}

- (void) closeFloatingActionMenu {
    if (_initTop < 0) [self toggleFloatingActionMenu:nil];
}

- (void) getNearest:(id)sender {
    
    MPMenuItem* selectedItem = [_menuItemModels objectAtIndex:((UIButton*)sender).tag];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowNearest" object: selectedItem.categoryKey];
    
    [self toggleFloatingActionMenu:nil];
}

@end
