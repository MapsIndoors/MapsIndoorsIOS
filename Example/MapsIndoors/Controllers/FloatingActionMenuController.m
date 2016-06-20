//
//  FloatingActionMenuController.m
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 08/09/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import "FloatingActionMenuController.h"
#import "UIColor+AppColor.h"
@import VCMaterialDesignIcons;


@interface FloatingActionMenuController ()

@end

@implementation FloatingActionMenuController {
    
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupFloatingActionBtn];
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
    MDButton *restRoomBtn = [[MDButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40) type:MDButtonTypeFloatingAction rippleColor:[UIColor appLightPrimaryColor]];
    restRoomBtn.tag = 0;
    [restRoomBtn addTarget:self action:@selector(getNearest:) forControlEvents:UIControlEventTouchDown];
    MDButton *stairsBtn = [[MDButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40) type:MDButtonTypeFloatingAction rippleColor:[UIColor appLightPrimaryColor]];
    stairsBtn.tag = 1;
    [stairsBtn addTarget:self action:@selector(getNearest:) forControlEvents:UIControlEventTouchDown];
    MDButton *entranceBtn = [[MDButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40) type:MDButtonTypeFloatingAction rippleColor:[UIColor appLightPrimaryColor]];
    entranceBtn.tag = 2;
    [entranceBtn addTarget:self action:@selector(getNearest:) forControlEvents:UIControlEventTouchDown];
    MDButton *nearestBtn = [[MDButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60) type:MDButtonTypeFloatingAction rippleColor:[UIColor colorWithWhite:255 alpha:.2f]];
    
    restRoomBtn.backgroundColor = [UIColor whiteColor];
    stairsBtn.backgroundColor = [UIColor whiteColor];
    entranceBtn.backgroundColor = [UIColor whiteColor];
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
    [nearestBtn setTitle:@"FIND NEAREST" forState:UIControlStateNormal];
    [nearestBtn setTitleEdgeInsets:UIEdgeInsetsMake(3.0f, -190.0f, 0.0f, 20.0f)];
    
    UIImageView* imageView1 = [[UIImageView alloc] initWithFrame:restRoomBtn.frame];
    imageView1.contentMode = UIViewContentModeCenter;
    imageView1.image = [UIImage imageNamed:@"RestroomBlack"];
    imageView1.image = [imageView1.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imageView1.tintColor = [UIColor appSecondaryTextColor];
    [restRoomBtn addSubview:imageView1];
    //[restRoomBtn setTitle:@"Restrooms" forState:UIControlStateNormal];
    
    UIImageView* imageView2 = [[UIImageView alloc] initWithFrame:stairsBtn.frame];
    imageView2.contentMode = UIViewContentModeCenter;
    imageView2.image = [UIImage imageNamed:@"StairsBlack"];
    imageView2.image = [imageView2.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imageView2.tintColor = [UIColor appSecondaryTextColor];
    [stairsBtn addSubview:imageView2];
    //[stairsBtn setTitle:@"Stairs" forState:UIControlStateNormal];
    
    UIImageView* imageView3 = [[UIImageView alloc] initWithFrame:entranceBtn.frame];
    imageView3.contentMode = UIViewContentModeCenter;
    imageView3.image = [UIImage imageNamed:@"ExitBlack"];
    imageView3.image = [imageView3.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    imageView3.tintColor = [UIColor appSecondaryTextColor];
    [entranceBtn addSubview:imageView3];
    //[entranceBtn setTitle:@"Entrance" forState:UIControlStateNormal];
    
    _menuOpenBtnImageView = imageView;
    
    _menuItems = @[restRoomBtn, stairsBtn, entranceBtn];
    
    
    [_menuOpenContainerView addSubview:nearestBtn];
    [itemsView addSubview:restRoomBtn];
    [itemsView addSubview:stairsBtn];
    [itemsView addSubview:entranceBtn];
    
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
    
    NSString* nearestQuery = [@[@"toilet",@"stairs",@"entrance"] objectAtIndex:((UIButton*)sender).tag];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowNearest" object: nearestQuery];
    
    [self toggleFloatingActionMenu:nil];
}


@end
