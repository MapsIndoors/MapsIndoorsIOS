//
//  OfflineMessageViewController.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 11/01/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "OfflineMessageViewController.h"
#import "NSObject+MPNetworkReachability.h"
#import "UIColor+AppColor.h"
#import "UINavigationController+TransparentNavigationController.h"
#import "MPToastView.h"
#import <PureLayout/PureLayout.h>
#import "LocalizedStrings.h"
#import <VCMaterialDesignIcons/VCMaterialDesignIcons.h>


@interface OfflineMessageViewController ()

@property (weak, nonatomic) IBOutlet MPToastView*       offlineMessage;
@property (weak, nonatomic) IBOutlet UIImageView*       offlineImageView;
@property (weak, nonatomic) IBOutlet UILabel*           offlineHeadingLabel;
@property (weak, nonatomic) IBOutlet UILabel*           offlineMessageLabel;
@property (weak, nonatomic) IBOutlet UIButton*          settingsButton;

@end


@implementation OfflineMessageViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    self.title = [NSBundle mainBundle].infoDictionary[@"CFBundleDisplayName"] ?: [NSBundle mainBundle].infoDictionary[@"CFBundleName"];
    
    self.offlineHeadingLabel.text = kLangNoInternet;
    self.offlineHeadingLabel.font = [UIFont systemFontOfSize:28];
    self.offlineHeadingLabel.textColor = [UIColor darkGrayColor];
    
    UIImage*    img = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_cloud_off fontSize:72.f].image;
    self.offlineImageView.tintColor = [UIColor lightGrayColor];
    self.offlineImageView.image = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    self.offlineMessageLabel.textColor = [UIColor darkGrayColor];
    self.offlineMessageLabel.text = kLangNoInternetMessage;
    
    self.settingsButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.settingsButton setTitleColor:[UIColor appTertiaryHighlightColor] forState:UIControlStateNormal];
    
    [self.navigationController resetNavigationBar];
    self.navigationController.navigationBar.backgroundColor = [UIColor appPrimaryColor];
    
    __weak typeof(self)weakSelf = self;
    [self mp_onReachabilityChange:^(BOOL networkIsReachable) {
        if ( networkIsReachable ) {
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];

    [self showOfflineToast];
}


#pragma mark - Offline handling

- (void) showOfflineToast {
    
    if ( self.offlineMessage == nil ) {
        
        NSString*       infoText = kLangInitOfflineDataUnavailable;
        MPToastView*    t = [[MPToastView newWithMessage:infoText] configureForAutoLayout];
        CGFloat         height = 44 + self.bottomLayoutGuide.length;
        CGRect  r = CGRectMake(0, self.view.bounds.size.height -height, self.view.bounds.size.width, height);
        t.frame = r;
        t.alpha = 0;
        [self.view addSubview:t];
        [t autoSetDimension:ALDimensionHeight toSize:height];
        [t autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeTop];
        [t layoutIfNeeded];     // Without this, the label animates into position in a weird way ;-)
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

- (IBAction)launchAppSettings:(id)sender {

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
}


@end
