//
//  MPRouteSettingsViewController.m
//  MapsIndoors App
//
//  Created by Michael Bech Hansen on 18/06/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//

#import "MPRouteSettingsViewController.h"
#import "MPUserRoleManager.h"
#import <MapsIndoors/MapsIndoors.h>

#ifdef BUILDING_SDK_APP
    #import "MPRoutingProvider+Private.h"
    #import "MPPathOptimization.h"
#endif


typedef NS_ENUM(NSUInteger, RouteSettingSection) {
    RouteSettingSection_UserProfiles,

#if BUILDING_SDK_APP
    RouteSettingSection_RoutingSource,
    RouteSettingSection_RouteOptimization,
#endif
    RouteSettingSection_DisplayedSectionsCount      // Section below this point is not shown!
};



@interface MPRouteSettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView*   tableView;

@end


@implementation MPRouteSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = NSLocalizedString(@"Route Settings",);
}

- (void) notifyRouteSettingsChanged {

    if ( self.onRouteSettingsChanged ) {
        self.onRouteSettingsChanged();
    }
}


#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {

    return RouteSettingSection_DisplayedSectionsCount;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSInteger   numberOfRows = 0;

    switch ( (RouteSettingSection)section ) {
        case RouteSettingSection_UserProfiles:
            numberOfRows = self.userRoleManager.availableUserRoles.count;
            break;

#if BUILDING_SDK_APP
        case RouteSettingSection_RoutingSource:
            numberOfRows = 3;
            break;
        case RouteSettingSection_RouteOptimization:
            numberOfRows = 4;
            break;
#endif

        case RouteSettingSection_DisplayedSectionsCount:
            break;
    }

    return numberOfRows;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    switch ( (RouteSettingSection)section ) {
        case RouteSettingSection_UserProfiles:              return NSLocalizedString(@"App User Roles", );
#if BUILDING_SDK_APP
        case RouteSettingSection_RoutingSource:             return @"Routing Provider";
        case RouteSettingSection_RouteOptimization:         return @"Route Path Optimization";
#endif
        case RouteSettingSection_DisplayedSectionsCount:    break;
    }

    return nil;
}

- (NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {

    switch ( (RouteSettingSection)section ) {
        case RouteSettingSection_UserProfiles:              return NSLocalizedString(@"Choose the App User Roles you are part of. This only affacts the directions you get, not the locations you see on the map", );
#if BUILDING_SDK_APP
        case RouteSettingSection_RoutingSource:
        case RouteSettingSection_RouteOptimization:         return @"MapsPeople internal - debugging only";
#endif
        case RouteSettingSection_DisplayedSectionsCount:    break;
    }

    return nil;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"routeSettingsCell" forIndexPath:indexPath];

    [self configureCell:cell forRowAtIndexPath:indexPath];

    return cell;
}

- (void) configureCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    switch ( (RouteSettingSection)indexPath.section ) {
        case RouteSettingSection_UserProfiles: {

            NSUInteger  ix = indexPath.row;
            MPUserRole* userRole = (ix < self.userRoleManager.availableUserRoles.count) ? self.userRoleManager.availableUserRoles[ix] : nil;
            cell.textLabel.text = userRole.userRoleName;

            BOOL    isActive = [self.userRoleManager.activeUserRoles containsObject:userRole];
            cell.accessoryType = isActive ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            break;
        }

#if BUILDING_SDK_APP
        case RouteSettingSection_RoutingSource:
            switch ( (RoutingServiceSelection)indexPath.row ) {
                case RoutingServiceSelection_Auto:
                    cell.textLabel.text = @"Auto";
                    break;
                case RoutingServiceSelection_ForceOnlineRouting:
                    cell.textLabel.text = @"Online";
                    break;
                case RoutingServiceSelection_ForceOfflineRouting:
                    cell.textLabel.text = @"Offline";
                    break;
            }
            cell.accessoryType = MPRoutingProvider.globalRoutingServiceSelectionStrategy == indexPath.row ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
            break;

        case RouteSettingSection_RouteOptimization:

            switch ( indexPath.row ) {
                case 0:
                    cell.textLabel.text = @"None";
                    cell.accessoryType = (MPPathOptimization.pathOptimizationStrategy & MPPathOptimizationStrategy_All) == 0 ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
                    break;
                case 1:
                    cell.textLabel.text = @"Line-O-Sight Optimization";
                    cell.accessoryType = (MPPathOptimization.pathOptimizationStrategy & MPPathOptimizationStrategy_LineOfSight) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
                    break;
                case 2:
                    cell.textLabel.text = @"Line Overshoot Prevention";
                    cell.accessoryType = (MPPathOptimization.pathOptimizationStrategy & MPPathOptimizationStrategy_PreventOvershoot) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
                    break;
                case 3:
                    cell.textLabel.text = @"Optimize All Routing Graphs";
                    cell.accessoryType = (MPPathOptimization.pathOptimizationStrategy & MPPathOptimizationStrategy_AlwaysOptimize) ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
                    break;
            }
            break;
#endif

        case RouteSettingSection_DisplayedSectionsCount:
            break;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    switch ( (RouteSettingSection)indexPath.section ) {

        case RouteSettingSection_UserProfiles: {
            NSUInteger      index = indexPath.row;
            MPUserRole*     userRole = (index < self.userRoleManager.availableUserRoles.count) ? self.userRoleManager.availableUserRoles[index] : nil;

            [self.userRoleManager toggleActivationOfUserRole:userRole];

            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self notifyRouteSettingsChanged];
            break;
        }

#if BUILDING_SDK_APP
        case RouteSettingSection_RoutingSource:
                if ( MPRoutingProvider.globalRoutingServiceSelectionStrategy != indexPath.row ) {
                    MPRoutingProvider.globalRoutingServiceSelectionStrategy = indexPath.row;
                    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
                    [self notifyRouteSettingsChanged];
                }
            break;

        case RouteSettingSection_RouteOptimization: {

            switch ( indexPath.row ) {
                case 0:
                    if ( MPPathOptimization.pathOptimizationStrategy & MPPathOptimizationStrategy_All ) {
                        MPPathOptimization.pathOptimizationStrategy &= ~MPPathOptimizationStrategy_All;
                    } else {
                        MPPathOptimization.pathOptimizationStrategy |= MPPathOptimizationStrategy_All;
                    }
                    break;
                case 1:
                    MPPathOptimization.pathOptimizationStrategy ^= MPPathOptimizationStrategy_LineOfSight;
                    if ( (MPPathOptimization.pathOptimizationStrategy & MPPathOptimizationStrategy_LineOfSight) == 0 ) {        // Without line-of-sight, prevent overshoot is not possible.
                        MPPathOptimization.pathOptimizationStrategy &= ~MPPathOptimizationStrategy_PreventOvershoot;
                    }
                    break;
                case 2:
                    MPPathOptimization.pathOptimizationStrategy ^= MPPathOptimizationStrategy_PreventOvershoot;
                    if ( MPPathOptimization.pathOptimizationStrategy & MPPathOptimizationStrategy_PreventOvershoot ) {        // Prevent overshoot requires line-of-sight.
                        MPPathOptimization.pathOptimizationStrategy |= MPPathOptimizationStrategy_LineOfSight;
                    }
                    break;
                case 3:
                    MPPathOptimization.pathOptimizationStrategy ^= MPPathOptimizationStrategy_AlwaysOptimize;
                    break;
            }

            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self notifyRouteSettingsChanged];
            break;
        }
#endif

        case RouteSettingSection_DisplayedSectionsCount:
            break;
    }
}

@end
