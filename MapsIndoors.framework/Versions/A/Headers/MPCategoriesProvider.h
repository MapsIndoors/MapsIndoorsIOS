//
//  MPCategoriesProvider.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 18/01/16.
//  Copyright  Daniel Nielsen. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void(^mpCategoriesHandlerBlockType)(NSArray* categories, NSError* error);


/**
 * Categories provider delegate.
 */
@protocol MPCategoriesProviderDelegate <NSObject>
/**
 * Categories data ready event method.
 * @param CategoriesCollection The Categories data collection.
 */
@required
- (void) onCategoriesReady: (NSArray*)categories;
@end

/**
 * Categories provider interface, that defines a delegate and a method for Categories queries.
 */
@interface MPCategoriesProvider : NSObject
/**
 * Categories provider delegate.
 */
@property (weak) id <MPCategoriesProviderDelegate> delegate;
/**
 * Get Categories from this provider.
 */
- (void)getCategoriesAsync: (NSString*) solutionId locale: (NSString*) locale;
/**
 * Get Categories from this provider and provide a callback handler.
 */
- (void)getCategoriesAsync: (NSString*) solutionId locale: (NSString*) locale completionHandler: (mpCategoriesHandlerBlockType) completionHandler;
@end
