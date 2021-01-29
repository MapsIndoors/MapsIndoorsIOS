//
//  MPUserRoleManager.m
//  MapsIndoors App
//
//  Created by Michael Bech Hansen on 11/06/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//

#import "MPUserRoleManager.h"
#import <MapsIndoors/MapsIndoors.h>
#import "AppNotifications.h"


@interface MPUserRoleManager ()

@property (nonatomic, strong, readwrite, nullable) NSArray<MPUserRole*>*    availableUserRoles;
@property (nonatomic, strong, readwrite, nullable) NSError*                 error;

@end


@implementation MPUserRoleManager

- (instancetype) init {

    self = [super init];
    if ( self ) {
        [self fetchAvailableUserRoles];
    }
    return self;
}


- (void) fetchAvailableUserRoles {

    __weak typeof(self)weakSelf = self;
    [[MPSolutionProvider new] getUserRolesWithCompletion:^(NSArray<MPUserRole *> * _Nullable userRoles, NSError * _Nullable error) {
        weakSelf.error = error;

        if ( !error ) {
            weakSelf.availableUserRoles = userRoles;
            weakSelf.activeUserRoles = [weakSelf getActiveUserRoleObjects];
        }

        [AppNotifications postUserRolesChangedNotification];
    }];
}


- (NSString*) userDefaultsKeyForActiveUserRoles {

    return [NSString stringWithFormat:@"mi-activeuserroles-%@", [MapsIndoors getMapsIndoorsAPIKey]];
}


- (NSSet<NSString*>*) loadActiveUserRoleIds {

    NSString*               s = [[NSUserDefaults standardUserDefaults] stringForKey: [self userDefaultsKeyForActiveUserRoles]];
    NSArray<NSString*>*     userRoleIds = [s componentsSeparatedByString:@","];
    return [NSSet setWithArray: userRoleIds];
}


- (NSArray<MPUserRole*>*) getActiveUserRoleObjects {

    NSSet<NSString*>*               activeUserRoleIds = [self loadActiveUserRoleIds];
    NSMutableArray<MPUserRole*>*    activeUserRoles = [NSMutableArray array];

    if ( activeUserRoleIds.count ) {
        for ( MPUserRole* userRole in self.availableUserRoles ) {
            if ( [activeUserRoleIds containsObject:userRole.userRoleId] ) {
                [activeUserRoles addObject:userRole];
            }
        }
    }

    return [activeUserRoles copy];
}


- (void) setActiveUserRoles:(NSArray<MPUserRole *> *)activeUserRoles {

    // Persist the ids of the active user roles:
    NSSet<NSString*>*   activeUserRoleIds = [NSSet setWithArray:[activeUserRoles valueForKeyPath:@"userRoleId"]];
    [[NSUserDefaults standardUserDefaults] setObject:[activeUserRoleIds.allObjects componentsJoinedByString:@","] forKey:[self userDefaultsKeyForActiveUserRoles]];

    _activeUserRoles = [self getActiveUserRoleObjects];

    MapsIndoors.userRoles = _activeUserRoles;

    [AppNotifications postUserRolesChangedNotification];
}


- (void) toggleActivationOfUserRole:(MPUserRole*)userRole {

    if ( [self.activeUserRoles containsObject:userRole] ) {
        NSMutableArray<MPUserRole*>*    activeRoles = [self.activeUserRoles mutableCopy];
        [activeRoles removeObject:userRole];
        self.activeUserRoles = [activeRoles copy];

    } else if ( [self.availableUserRoles containsObject:userRole] ) {

        self.activeUserRoles = [self.activeUserRoles arrayByAddingObject:userRole];
    }
}


@end
