//
//  MPUserRoleProvider+Private.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 14/06/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//

#import "MPUserRoleProvider.h"


NS_ASSUME_NONNULL_BEGIN

@interface MPUserRoleProvider (Private)

/**
 Build url for fetching user roles.

 @param solutionId solutionId
 @param locale locale
 @return url or nil
 */
+ (nullable NSString*) urlForFetchingUserRoles:(NSString *)solutionId locale:(NSString *)locale;

@end

NS_ASSUME_NONNULL_END
