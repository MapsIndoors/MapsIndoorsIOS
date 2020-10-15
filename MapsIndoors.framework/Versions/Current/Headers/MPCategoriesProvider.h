//
//  MPCategoriesProvider.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 18/01/16.
//  Copyright © 2016-2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPCategories.h"
#import "MPDefines.h"

/**
 Callback block for getting category data or handling error in doing so.
 
 @param categories Array of categories. Will be nil if an error occurred
 @param error Error object. Will be nil if fetching was complete
 */
typedef void(^mpCategoriesHandlerBlockType)( NSArray<MPDataField*>* _Nullable categories, NSError* _Nullable error );


/**
 Categories provider delegate.
 */
@protocol MPCategoriesProviderDelegate <NSObject>

/**
 Categories data ready event method.
 @param  CategoriesCollection The Categories data collection.
 */

@required
- (void) onCategoriesReady: (nullable NSArray*)categories;
@end

/**
 A categories provider acts as a service for the location categories belonging to a specific MapsIndoors solution/dataset.
 */
@interface MPCategoriesProvider : NSObject

/**
 Categories provider delegate.
 */
@property (nonatomic, weak, nullable) id <MPCategoriesProviderDelegate> delegate;

/**
 Get categories from the specified solution.
 
 */
- (void)getCategories;
/**
 Get Categories from this provider and provide a callback handler.
 */
- (void)getCategoriesWithCompletion: (nullable mpCategoriesHandlerBlockType) completionHandler;
/**
 Determine if cached or preloaded data is available for the given solutionId.
 
 @param solutionId solutionId to check for offline data availability.
 @param language Language to check for offline data availability.
 @return YES if offline or preloaded data is available, else NO,
 */
+ (BOOL) isOfflineDataAvailableForSolutionId:(nonnull NSString*)solutionId language:(nonnull NSString*)language;

@end
