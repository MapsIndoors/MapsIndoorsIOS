//
//  AppInfoHeaderTableViewCell.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 11/10/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import "AppInfoHeaderTableViewCell.h"
#import "UIColor+AppColor.h"
#import "AppVariantData.h"
#import "LocalizedStrings.h"


@interface AppInfoHeaderTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView*   appBrandImageView;
@property (weak, nonatomic) IBOutlet UILabel*       appNameLabel;
@property (weak, nonatomic) IBOutlet UILabel*       appProviderNameLabel;
@property (weak, nonatomic) IBOutlet UIButton*      logoutButton;

@property (nonatomic, copy) void(^providerNameTapAction)(void);

@end


@implementation AppInfoHeaderTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];

    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(appProviderNameTapped:)];
    [self.appProviderNameLabel addGestureRecognizer:tapGesture];
    [self configureLogOutButton];
}

- (void) configureWithAppName:(NSString*)appName providerName:(NSString*)providerName  providerNameTapAction:(void(^)(void))providerNameTapAction {
    
    self.providerNameTapAction = providerNameTapAction;
    
    // Because we have some Roboto font overrides, which apparently does not work with storyboards.
    // appNameLabel.font gets set to Roboto 15 non-bold, event though the storyboard says boldSystemFont 17
    self.appNameLabel.font = [UIFont boldSystemFontOfSize:17];
    self.appProviderNameLabel.font = [UIFont boldSystemFontOfSize:15];

    self.appNameLabel.text = appName;
    self.appProviderNameLabel.text = providerName;
    self.appProviderNameLabel.textColor = self.providerNameTapAction ? [UIColor appTertiaryHighlightColor] : [UIColor appPrimaryTextColor];
}

- (void) appProviderNameTapped:(UIGestureRecognizer*)gestureRecognizer; {

    if ( self.providerNameTapAction ) {
        self.providerNameTapAction();
    }
}

#pragma mark - Log out button

- (void) configureLogOutButton {

    BOOL    haveLogout = [AppVariantData sharedAppVariantData].logoutNotificationName != nil;

    self.logoutButton.hidden = haveLogout == NO;
    if ( haveLogout ) {
        [self.logoutButton setTitle:kLangLogOut forState:UIControlStateNormal];
        [self.logoutButton setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        self.logoutButton.backgroundColor = [UIColor colorFromRGBA:@"#FFD300"];

        //        self.loginBackgroundView.layer.cornerRadius = 8;
        //        self.loginBackgroundView.layer.masksToBounds = NO;
        self.logoutButton.layer.shadowOffset = CGSizeMake( 0, 3 );
        self.logoutButton.layer.shadowRadius = 8;
        self.logoutButton.layer.shadowOpacity = 0.08;
        self.logoutButton.layer.shadowColor = UIColor.blackColor.CGColor;

        self.logoutButton.layer.cornerRadius = 4;

        [self.logoutButton addTarget:self action:@selector(onLogoutTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void) onLogoutTapped:(id)sender {

    [[NSNotificationCenter defaultCenter] postNotificationName:[AppVariantData sharedAppVariantData].logoutNotificationName object:self];
}

@end
