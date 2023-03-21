//
//  MPSolutionProvider.h
//  MapsIndoors for iOS
//
//  Created by Martin Hansen on 7/23/15.
//  Copyright (c) 2015-2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPDefines.h"

@class MPSolutionInternal;
@class MPUserRole;


typedef void(^mpSolutionHandlerBlockType)(MPSolutionInternal* _Nullable solution, NSError* _Nullable error);
typedef void(^mpUserRoleCompletion)( NSArray<MPUserRole*>* _Nullable userRoles, NSError* _Nullable error );

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Solution provider delegate.
 */
@protocol MPSolutionProviderDelegate <NSObject>

/**
 Solution data ready event method.
 - Parameter solution: The solution data.
 */
@required
- (void) onSolutionsReady: (nonnull MPSolutionInternal*)solution;

@end

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Solution provider interface, that defines a delegate and a method for solution queries.
 */
@interface MPSolutionProvider : NSObject

/**
 Solution provider delegate.
 */
@property (nonatomic, weak, nullable) id <MPSolutionProviderDelegate> delegate;

/**
 Get solution from this provider.
 */
- (void)getSolution;
/**
 Get solution from this provider and supply a callback handler function.
 */
- (void)getSolutionWithCompletion: (nullable mpSolutionHandlerBlockType)completionHandler;

/**
 Determine if cached or preloaded data is available for the given solutionId.
 
 - Parameter solutionId: solutionId to check for offline data availability.
 - Returns: YES if offline or preloaded data is available, else NO,
 */
+ (BOOL) isOfflineDataAvailableForSolutionId:(nonnull NSString*)solutionId;

/**
 Get user roles associated with the solution

 - Parameter completionHandler: called when user roles or error has been found
 */
- (void) getUserRolesWithCompletion:(nonnull mpUserRoleCompletion)completionHandler;

@end
