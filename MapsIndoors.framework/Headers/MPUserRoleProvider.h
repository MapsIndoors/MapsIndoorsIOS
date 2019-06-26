//
//  MPUserRoleProvider.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 07/06/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MPUserRole;


NS_ASSUME_NONNULL_BEGIN

/**
 Callback block for getting user roles

 @param userRoles list of user roles, possibly empty
 @param error error, nil of no error occured
 */
typedef void(^mpUserRoleCompletion)( NSArray<MPUserRole*>* _Nullable userRoles, NSError* _Nullable error );


@interface MPUserRoleProvider : NSObject

- (void) getUserRolesWithCompletion:(mpUserRoleCompletion)completionHandler;

/**
 Determine if cached or preloaded data is available for the given solutionId.

 @param solutionId solutionId to check for offline data availability.
 @param language Language to check for offline data availability.
 @return YES if offline or preloaded data is available, else NO,
 */
+ (BOOL) isOfflineDataAvailableForSolutionId:(nonnull NSString*)solutionId language:(nonnull NSString*)language;

@end

NS_ASSUME_NONNULL_END
