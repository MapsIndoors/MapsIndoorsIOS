//
//  MPSolutionProvider.h
//  MapsIndoorSDK for iOS
//
//  Created by Martin Hansen on 7/23/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPSolution.h"
#import "MPMapExtend.h"
/**
 * Solution provider delegate.
 */
@protocol MPSolutionProviderDelegate <NSObject>
/**
 * Solution data ready event method.
 * @param solutionCollection The solution data collection.
 */
@required
- (void) onSolutionsReady: (MPSolution*)solution;
@end
/**
 * Solution provider interface, that defines a delegate and a method for solution queries.
 */
@interface MPSolutionProvider : NSObject
/**
 * Solution provider delegate.
 */
@property (weak) id <MPSolutionProviderDelegate> delegate;
/**
 * Get solutions from this provider.
 */
- (void)getSolutionAsync: (NSString*) solutionId;
@end
