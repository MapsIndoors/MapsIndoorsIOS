//
//  ContainerViewController.m
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 18/08/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import "ContainerViewController.h"
@import VCMaterialDesignIcons;
#import "Global.h"

@interface ContainerViewController ()

@end

@implementation ContainerViewController {
    UISplitViewController* _viewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNeedsStatusBarAppearanceUpdate];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [Global setupPositioning];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) setEmbeddedViewController:(UISplitViewController*) splitViewController {
    if (splitViewController != nil) {
        _viewController = splitViewController;
        
        [self addChildViewController:_viewController];
        [self.view addSubview: _viewController.view];
        [_viewController didMoveToParentViewController:self];
        
        [self setOverrideTraitCollection: [UITraitCollection traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassRegular] forChildViewController:_viewController];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            _viewController.preferredPrimaryColumnWidthFraction = .3;
            _viewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
        } else {
            _viewController.preferredPrimaryColumnWidthFraction = .9;
            _viewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryOverlay;
            
            //Initially hide master view
            UIBarButtonItem* btn = _viewController.displayModeButtonItem;
            [[UIApplication sharedApplication] sendAction:btn.action
                                                       to:btn.target
                                                     from:nil
                                                 forEvent:nil];
            
        }
        _viewController.delegate = self;
        _viewController.extendedLayoutIncludesOpaqueBars = YES;
        
    }
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
//    if (size.width > size.height){
//        [self setOverrideTraitCollection: [UITraitCollection traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassRegular] forChildViewController:_viewController];
//    }
//    else{
//        [self setOverrideTraitCollection: nil forChildViewController:_viewController];
//    }
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
}

- (void)splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"MenuOpenedOrClosed" object:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
