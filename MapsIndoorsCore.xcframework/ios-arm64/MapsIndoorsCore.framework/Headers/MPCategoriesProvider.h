//
//  MPCategoriesProvider.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 18/01/16.
//  Copyright © 2016-2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPDataField.h"

/**
 Callback block for getting category data or handling error in doing so.
 
 - Parameter categories: Array of categories. Will be nil if an error occurred
 - Parameter error: Error object. Will be nil if fetching was complete
 */
typedef void(^mpCategoriesHandlerBlockType)( NSArray<MPDataField*>* _Nullable categories, NSError* _Nullable error );


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Categories provider delegate.
 */
@protocol MPCategoriesProviderDelegate <NSObject>

/**
 Categories data ready event method.
 - Parameter categories: The Categories data collection.
 */
@required
- (void) onCategoriesReady: (nullable NSArray*)categories;
@end

/// > Warning: [INTERNAL - DO NOT USE]
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
 - Parameter completion: Block with code to execute when categories become available.
 */
- (void)getCategoriesWithCompletion: (nullable mpCategoriesHandlerBlockType) completion;
/**
 Determine if cached or preloaded data is available for the given solutionId.
 
 - Parameter solutionId: solutionId to check for offline data availability.
 - Parameter language: Language to check for offline data availability.
 - Returns: YES if offline or preloaded data is available, else NO,
 */
+ (BOOL) isOfflineDataAvailableForSolutionId:(nonnull NSString*)solutionId language:(nonnull NSString*)language;

@end
