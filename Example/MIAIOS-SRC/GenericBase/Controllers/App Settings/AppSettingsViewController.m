//
//  AppSettingsViewController.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 08/12/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "AppSettingsViewController.h"
#import "MPUserRoleManager.h"
#import "UINavigationController+TransparentNavigationController.h"
#import "UIViewController+Custom.h"
#import <MapsIndoors/MapsIndoors.h>


typedef NS_ENUM(NSUInteger, AppSettingSection) {
    AppSettingSection_UserProfiles,

    AppSettingSection_DisplayedSectionsCount      // Section below this point is not shown!
};



@interface AppSettingsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end


@implementation AppSettingsViewController

- (void) viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = NSLocalizedString(@"Settings",);
}

- (void) viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    // Configure navBar; transfer searchbar to navBar titleView:
    [self.navigationController resetNavigationBar];
    [self presentCustomBackButton];
}


#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {

    return AppSettingSection_DisplayedSectionsCount;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger   numberOfRows = 0;

    switch ( (AppSettingSection)section ) {
        case AppSettingSection_UserProfiles:
            numberOfRows = self.userRoleManager.availableUserRoles.count;
            break;

        case AppSettingSection_DisplayedSectionsCount:
            break;
    }

    return numberOfRows;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    switch ( (AppSettingSection)section ) {
        case AppSettingSection_UserProfiles:              return NSLocalizedString(@"App User Roles", );
        case AppSettingSection_DisplayedSectionsCount:    break;
    }

    return nil;
}

- (NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {

    switch ( (AppSettingSection)section ) {
        case AppSettingSection_UserProfiles:              return NSLocalizedString(@"Choose the App User Roles you are part of. This only affacts the directions you get, not the locations you see on the map", );
        case AppSettingSection_DisplayedSectionsCount:    break;
    }

    return nil;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"appSettingsCell" forIndexPath:indexPath];

    [self configureCell:cell forRowAtIndexPath:indexPath];

    return cell;
}

- (void) configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    switch ( (AppSettingSection)indexPath.section ) {
        case AppSettingSection_UserProfiles: {

            NSUInteger  ix = indexPath.row;
            MPUserRole* userRole = (ix < self.userRoleManager.availableUserRoles.count) ? self.userRoleManager.availableUserRoles[ix] : nil;
            cell.textLabel.text = userRole.userRoleName;

            BOOL    isActive = [self.userRoleManager.activeUserRoles containsObject:userRole];
            cell.accessoryType = isActive ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            break;
        }

        case AppSettingSection_DisplayedSectionsCount:
            break;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    switch ( (AppSettingSection)indexPath.section ) {

        case AppSettingSection_UserProfiles: {
            NSUInteger      index = indexPath.row;
            MPUserRole*     userRole = (index < self.userRoleManager.availableUserRoles.count) ? self.userRoleManager.availableUserRoles[index] : nil;

            [self.userRoleManager toggleActivationOfUserRole:userRole];

            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            break;
        }

        case AppSettingSection_DisplayedSectionsCount:
            break;
    }
}


@end
