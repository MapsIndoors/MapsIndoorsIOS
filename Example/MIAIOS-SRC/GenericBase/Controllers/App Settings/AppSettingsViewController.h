//
//  AppSettingsViewController.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 08/12/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MPUserRoleManager;


NS_ASSUME_NONNULL_BEGIN

@interface AppSettingsViewController : UIViewController

@property (nonatomic, weak) MPUserRoleManager*      userRoleManager;

@end

NS_ASSUME_NONNULL_END
