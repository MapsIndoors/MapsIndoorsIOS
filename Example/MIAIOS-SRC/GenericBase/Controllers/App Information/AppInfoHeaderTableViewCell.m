//
//  AppInfoHeaderTableViewCell.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 11/10/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import "AppInfoHeaderTableViewCell.h"
#import "UIColor+AppColor.h"


@interface AppInfoHeaderTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView*   appBrandImageView;
@property (weak, nonatomic) IBOutlet UILabel*       appNameLabel;
@property (weak, nonatomic) IBOutlet UILabel*       appProviderNameLabel;

@property (nonatomic, copy) void(^providerNameTapAction)(void);

@end


@implementation AppInfoHeaderTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];

    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(appProviderNameTapped:)];
    [self.appProviderNameLabel addGestureRecognizer:tapGesture];
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

@end
