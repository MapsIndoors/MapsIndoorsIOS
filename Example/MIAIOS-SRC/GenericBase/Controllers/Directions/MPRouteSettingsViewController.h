//
//  MPRouteSettingsViewController.h
//  MapsIndoors App
//
//  Created by Michael Bech Hansen on 18/06/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MPUserRoleManager;


NS_ASSUME_NONNULL_BEGIN

@interface MPRouteSettingsViewController : UIViewController

@property (nonatomic, weak) MPUserRoleManager*      userRoleManager;
@property (nonatomic, nullable) void (^onRouteSettingsChanged)(void);

@end

NS_ASSUME_NONNULL_END
