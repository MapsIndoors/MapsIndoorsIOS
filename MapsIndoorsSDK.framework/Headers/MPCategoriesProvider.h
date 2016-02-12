//
//  MPCategoriesProvider.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 18/01/16.
//  Copyright © 2016 Daniel Nielsen. All rights reserved.
//

#import <Foundation/Foundation.h>

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
@end
