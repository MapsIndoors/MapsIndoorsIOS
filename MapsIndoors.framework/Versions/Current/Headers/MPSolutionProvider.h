//
//  MPSolutionProvider.h
//  MapsIndoors for iOS
//
//  Created by Martin Hansen on 7/23/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPSolution.h"
#import "MPMapExtend.h"

typedef void(^mpSolutionHandlerBlockType)(MPSolution* solution, NSError* error);

/**
 Solution provider delegate.
 */
@protocol MPSolutionProviderDelegate <NSObject>

/**
 Solution data ready event method.
 @param  solutionCollection The solution data collection.
 */
@required
- (void) onSolutionsReady: (MPSolution*)solution;

@end

/**
 Solution provider interface, that defines a delegate and a method for solution queries.
 */
@interface MPSolutionProvider : NSObject

/**
 Solution provider delegate.
 */
@property (weak) id <MPSolutionProviderDelegate> delegate;

/**
 Get solution from this provider.
 */
- (void)getSolutionAsync: (NSString*) solutionId DEPRECATED_MSG_ATTRIBUTE("Use getSolution instead");
/**
 Get solution from this provider and supply a callback handler function.
 */
- (void)getSolutionAsync: (NSString*) solutionId completionHandler: (mpSolutionHandlerBlockType)completionHandler DEPRECATED_MSG_ATTRIBUTE("Use getSolutionWithCompletion: instead");
/**
 Get solution from this provider.
 */
- (void)getSolution;
/**
 Get solution from this provider and supply a callback handler function.
 */
- (void)getSolutionWithCompletion: (mpSolutionHandlerBlockType)completionHandler;

/**
 Determine if cached or preloaded data is available for the given solutionId.
 
 @param solutionId
 @return YES if offline or preloaded data is available, else NO,
 */
+ (BOOL) isOfflineDataAvailableForSolutionId:(NSString*)solutionId;
@end
