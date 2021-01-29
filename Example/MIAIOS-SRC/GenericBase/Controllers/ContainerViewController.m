//
//  ContainerViewController.m
//  MIAIOS
//
//  Created by Daniel Nielsen on 18/08/15.
//  Copyright (c) 2015-2018 MapsPeople A/S. All rights reserved.
//


#import "ContainerViewController.h"
@import VCMaterialDesignIcons;
#import "Global.h"
#import "UIColor+AppColor.h"
#import "LocalizedStrings.h"
#import "NSObject+MPNetworkReachability.h"
#import "MPToastView.h"
#import <PureLayout/PureLayout.h>
#import <MapsIndoors/MapsIndoors.h>
#import "AppVariantData.h"
#import "NSObject+ContentSizeChange.h"
#import "AppFonts.h"
#import "BuildingInfoCache.h"
#import "AppFlowController.h"


@interface ContainerViewController () <UISplitViewControllerDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint*        splashIconVerticalPositionConstraint;
@property (weak, nonatomic) IBOutlet UIImageView*               brandIconImageView;
@property (weak, nonatomic) IBOutlet UILabel*                   welcomeLabel;
@property (weak, nonatomic) IBOutlet UILabel*                   loadingLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView*   loadingIndicator;
@property (strong, nonatomic)        UISplitViewController*     splitViewController;
@property (weak, nonatomic) IBOutlet UIView*                    dummyStatusBar;
@property (weak, nonatomic) IBOutlet UIView*                    dummyNavBar;
@property (weak, nonatomic) IBOutlet MPToastView*               offlineMessage;
@property (nonatomic) BOOL                                      didPresentOfflineWithNoDataScreen;
@property (nonatomic) BOOL                                      offlineDataIsAvailable;

@end


@implementation ContainerViewController

- (void) viewDidLoad {
    
    [super viewDidLoad];
    
    self.dummyNavBar.backgroundColor = [UIColor appPrimaryColor];
    self.dummyStatusBar.backgroundColor = [UIColor appDarkPrimaryColor];
    
    CGFloat h, s, b, a;
    self.view.backgroundColor = [UIColor appLaunchScreenColor];
    [self.view.backgroundColor getHue:&h saturation:&s brightness:&b alpha:&a];
    if (b + a > 1.72f) {
        self.welcomeLabel.textColor = [UIColor appPrimaryTextColor];
        self.loadingLabel.textColor = [UIColor appPrimaryTextColor];
        self.loadingIndicator.color = [UIColor appPrimaryTextColor];
    }
    
    self.navigationController.navigationBar.backgroundColor = [UIColor appPrimaryColor];

    self.welcomeLabel.font = [AppFonts sharedInstance].launscreenWelcomeMessageFont;
    self.loadingLabel.font = [AppFonts sharedInstance].launscreenLoadingMessageFont;

    self.welcomeLabel.text = [AppVariantData sharedAppVariantData].welcomeMessage ?: kLangSplashWelcome;
    self.loadingLabel.text = kLangSplashLoading;
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.splitViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"mainUI"];
    
    [self setOverrideTraitCollection: [UITraitCollection traitCollectionWithHorizontalSizeClass:UIUserInterfaceSizeClassRegular] forChildViewController:self.splitViewController];
    if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.splitViewController.preferredPrimaryColumnWidthFraction = .35;
        self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;
        self.splitViewController.maximumPrimaryColumnWidth = self.splitViewController.view.bounds.size.width*.35;
        self.splitViewController.minimumPrimaryColumnWidth = self.splitViewController.view.bounds.size.width*.35;
        
    } else {
        self.splitViewController.preferredPrimaryColumnWidthFraction = .90;
        self.splitViewController.preferredDisplayMode = UISplitViewControllerDisplayModePrimaryOverlay;
        self.splitViewController.maximumPrimaryColumnWidth = self.splitViewController.view.bounds.size.width*.90;
        self.splitViewController.minimumPrimaryColumnWidth = self.splitViewController.view.bounds.size.width*.90;
    }
    
    self.splitViewController.delegate = self;
    self.splitViewController.extendedLayoutIncludesOpaqueBars = YES;
    
    if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ) {
        [self prepareMainUI];
    }
    
    __weak typeof(self)weakSelf = self;
    [self mp_onReachabilityChange:^(BOOL isNetworkReachable) {
        if ( isNetworkReachable ) {
            [weakSelf hideOfflineToast];
        } else {
#if defined(MI_SDK_VERSION_MAJOR) && (MI_SDK_VERSION_MAJOR >= 2)
            [MapsIndoors checkOfflineDataAvailabilityAsync:^{
                [weakSelf showOfflineToast];
            }];
#endif
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onInvalidApiKeyNotification:) name:kMPNotificationApiKeyInvalid object:nil];

    [self mp_onContentSizeChange:^(DynamicTextSize dynamicTextSize) {
        weakSelf.welcomeLabel.font = [AppFonts sharedInstance].launscreenWelcomeMessageFont;
        weakSelf.loadingLabel.font = [AppFonts sharedInstance].launscreenLoadingMessageFont;
    }];
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if ( self.didPresentOfflineWithNoDataScreen == NO ) {
        
        self.splashIconVerticalPositionConstraint.constant = - 82;
        [self.view setNeedsLayout];
        
        self.welcomeLabel.alpha = 0;
        self.welcomeLabel.hidden = NO;
        
        self.loadingLabel.alpha = 0;
        self.loadingLabel.hidden = NO;
        
        self.loadingIndicator.alpha = 0;
        self.loadingIndicator.hidden = NO;
        
        [UIView animateKeyframesWithDuration:2 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
            
            [UIView addKeyframeWithRelativeStartTime:0.3 relativeDuration:0.3 animations:^{
                [self.view layoutIfNeeded];
            }];
            
            [UIView addKeyframeWithRelativeStartTime:0.4 relativeDuration:0.4 animations:^{
                self.welcomeLabel.alpha = 1;
            }];
            
            [UIView addKeyframeWithRelativeStartTime:0.5 relativeDuration:0.3 animations:^{
                self.loadingLabel.alpha = 1;
                self.loadingIndicator.alpha = 1;
            }];
            
        } completion:^(BOOL finished) {
            if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ) {
                [self prepareMainUI];
            }
            
            if ( [self mp_isNetworkReachable] || self.offlineDataIsAvailable ) {
                
                [self presentMainUI];

            } else {
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self performSegueWithIdentifier:@"offlineMessageSegue" sender:self];
                    self.didPresentOfflineWithNoDataScreen = YES;
                });
            }
            
            [self checkGoogleAPIKey];
        }];
    
    } else {
        
        // Coming back from "offline with no data screen", which means we must be online now... so go to the main UI.
        [self presentMainUI];
        [self checkGoogleAPIKey];
    }
    
}

- (void) prepareMainUI {
    
    [UIView performWithoutAnimation:^{

        self.splitViewController.view.alpha = 0;

        [self addChildViewController:self.splitViewController];
        [self.view addSubview: self.splitViewController.view];
        [self.splitViewController didMoveToParentViewController:self];
    }];
}

- (void) presentMainUI {
    
    if ( self.presentedViewController == nil ) {
        
        [UIView performWithoutAnimation:^{
            
            if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ) {
                NSString* venueId = [[NSUserDefaults standardUserDefaults] objectForKey:@"venue"];
                
                if ( venueId ) {
                    UIBarButtonItem* btn = self.splitViewController.displayModeButtonItem;
                    [[UIApplication sharedApplication] sendAction:btn.action
                                                               to:btn.target
                                                             from:nil
                                                         forEvent:nil];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationMenuOpenClose
                                                                        object:nil
                                                                      userInfo:@{ kNotificationMenuOpenClose_IsOpenKey : @(YES)}
                     ];
                }
            }
        }];
    }

    [UIView animateKeyframesWithDuration:1 delay:0 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0.7 relativeDuration:0.3 animations:^{
            self.splitViewController.view.alpha = 1;
            self.offlineMessage.alpha = 0;
        }];
        
    } completion:^(BOOL finished) {
        [self.offlineMessage removeFromSuperview];
        [self mp_stopMonitoringReachabilityChanges];
        // We first want the location permissions dialog when the map has appeared, except if our Google API Key is invalid:
        if ( [AppVariantData sharedAppVariantData].googleAPIKey.length > 0 ) {
            [Global setupPositioning];
        }
        // Hide a few things, since they are visible to the iOS accessibility system even when covered by the "main UI":
        self.welcomeLabel.hidden = YES;
        self.loadingLabel.hidden = YES;
        self.loadingIndicator.hidden = YES;

        [AppFlowController sharedInstance].splitViewController = self.splitViewController;
        [AppFlowController sharedInstance].mainUiIsReady = YES;
    }];

    [BuildingInfoCache sharedInstance]; // Preheat the building info cache.
}

- (void) splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode {
    
    BOOL    menuIsOpen = displayMode != UISplitViewControllerDisplayModePrimaryHidden;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationMenuOpenClose
                                                        object:nil
                                                      userInfo:@{ kNotificationMenuOpenClose_IsOpenKey : @(menuIsOpen)}
    ];
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - Offline handling

- (void) showOfflineToast {
    
    if ( self.offlineMessage == nil ) {

        NSString*       infoText = self.offlineDataIsAvailable ? kLangInitOfflineWithDataAvailable : kLangInitOfflineDataUnavailable;
        MPToastView*    t = [[MPToastView newWithMessage:infoText] configureForAutoLayout];
        CGFloat         height = 44 + self.bottomLayoutGuide.length;
        CGRect  r = CGRectMake(0, self.view.bounds.size.height -height, self.view.bounds.size.width, height);
        t.frame = r;
        t.alpha = 0;
        [self.view addSubview:t];
        [t autoSetDimension:ALDimensionHeight toSize:height];
        [t autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTop];
        [t layoutIfNeeded];     // Without this, the label animates into position (in a weird way ;-))
        self.offlineMessage = t;
        
        [UIView animateWithDuration:0.3 animations:^{
            t.alpha = 1;
        }];
    }
}

- (void) hideOfflineToast {
    
    if ( self.offlineMessage ) {
        
        [UIView animateWithDuration:0.3 animations:^{
            self.offlineMessage.alpha = 0;
        } completion:^(BOOL finished) {
            [self.offlineMessage removeFromSuperview];
        }];
    }
}

- (BOOL) offlineDataIsAvailable {
#if defined(MI_SDK_VERSION_MAJOR) && (MI_SDK_VERSION_MAJOR >= 2)
    return MapsIndoors.isOfflineDataAvailable;
#endif
    return NO;
}


#pragma mark - Invalid API key handling

- (void) onInvalidApiKeyNotification:(NSNotification*)notification {

    // Block UI when we have an invalid API key.
    
    NSString*   appProvider = [AppVariantData sharedAppVariantData].appProviderName;
    NSString*   msg = [NSString stringWithFormat:@"Contact %@ for more information", appProvider];
    UIAlertController*  alert = [UIAlertController alertControllerWithTitle:@"API Key Invalid" message:msg preferredStyle:UIAlertControllerStyleAlert];
    if (!(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
        alert.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - Invalid/missing Google API Key

- (void) checkGoogleAPIKey {

    if ( [AppVariantData sharedAppVariantData].googleAPIKey.length == 0 ) {
        
        // Block UI when we do have an invalid Google API key.
        
        NSString*   msg = @"Please add a valid Google API Key to mapsindoors.plist";
        UIAlertController*  alert = [UIAlertController alertControllerWithTitle:@"Google API Key Invalid" message:msg preferredStyle:UIAlertControllerStyleAlert];
        if (!(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
            alert.modalPresentationStyle = UIModalPresentationFullScreen;
        }
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
