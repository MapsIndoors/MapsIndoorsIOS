//
//  MPSolutionProvider.h
//  MapsIndoors for iOS
//
//  Created by Martin Hansen on 7/23/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPDefines.h"
#import "MPSolution.h"


typedef void(^mpSolutionHandlerBlockType)(MPSolution* _Nullable solution, NSError* _Nullable error);


/**
 Solution provider delegate.
 */
@protocol MPSolutionProviderDelegate <NSObject>

/**
 Solution data ready event method.
 @param  solutionCollection The solution data collection.
 */
@required
- (void) onSolutionsReady: (nonnull MPSolution*)solution;

@end

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
- (void)getSolutionAsync: (nonnull NSString*) solutionId MP_DEPRECATED_MSG_ATTRIBUTE("Use getSolution instead");
/**
 Get solution from this provider and supply a callback handler function.
 */
- (void)getSolutionAsync: (nonnull NSString*) solutionId completionHandler: (nullable mpSolutionHandlerBlockType)completionHandler MP_DEPRECATED_MSG_ATTRIBUTE("Use getSolutionWithCompletion: instead");
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
 
 @param solutionId solutionId to check for offline data availability.
 @return YES if offline or preloaded data is available, else NO,
 */
+ (BOOL) isOfflineDataAvailableForSolutionId:(nonnull NSString*)solutionId;
@end
