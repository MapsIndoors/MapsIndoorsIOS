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

- (IBAction)launchAppSettings:(id)sender {

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
}


@end
