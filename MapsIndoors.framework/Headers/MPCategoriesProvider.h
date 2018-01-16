//
//  MPCategoriesProvider.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 18/01/16.
//  Copyright  Daniel Nielsen. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 Callback block for getting category data or handling error in doing so.
 
 @param categories Array of categories. Will be nil if an error occurred
 @param error Error object. Will be nil if fetching was complete
 */
typedef void(^mpCategoriesHandlerBlockType)(NSArray* categories, NSError* error);


/**
 Categories provider delegate.
 */
@protocol MPCategoriesProviderDelegate <NSObject>

/**
 Categories data ready event method.
 @param  CategoriesCollection The Categories data collection.
 */

@required
- (void) onCategoriesReady: (NSArray*)categories;
@end

/**
 A categories provider acts as a service for the location categories belonging to a specific MapsIndoors solution/dataset.
 */
@interface MPCategoriesProvider : NSObject

/**
 Categories provider delegate.
 */
@property (weak) id <MPCategoriesProviderDelegate> delegate;

/**
 Get categories from the specified solution.

 @param solutionId MapsIndoors solution id string
 @param locale Specifies which language to fetch categories in. Uses 2 character ISO 639-1 representation
 */
- (void)getCategoriesAsync: (NSString*) solutionId locale: (NSString*) locale;

/**
 Get Categories from this provider and provide a callback handler.
 */
- (void)getCategoriesAsync: (NSString*) solutionId locale: (NSString*) locale completionHandler: (mpCategoriesHandlerBlockType) completionHandler;

/**
 Determine if cached or preloaded data is available for the given solutionId.
 
 @param solutionId
 @param language
 @return YES if offline or preloaded data is available, else NO,
 */
+ (BOOL) isOfflineDataAvailableForSolutionId:(NSString*)solutionId language:(NSString*)language;

@end
