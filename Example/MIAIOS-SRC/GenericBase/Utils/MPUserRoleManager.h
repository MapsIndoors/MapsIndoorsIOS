//
//  MPUserRoleManager.h
//  MapsIndoors App
//
//  Created by Michael Bech Hansen on 11/06/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MPUserRole;


NS_ASSUME_NONNULL_BEGIN

@interface MPUserRoleManager : NSObject

@property (nonatomic, strong, readonly, nullable) NSArray<MPUserRole*>*   availableUserRoles;
@property (nonatomic, strong, nullable)           NSArray<MPUserRole*>*   activeUserRoles;
@property (nonatomic, strong, readonly, nullable) NSError*                error;

- (void) toggleActivationOfUserRole:(MPUserRole*)userRole;

@end

NS_ASSUME_NONNULL_END
