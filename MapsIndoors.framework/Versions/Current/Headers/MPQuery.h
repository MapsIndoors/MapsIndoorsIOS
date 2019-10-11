//
//  MPLocationsQuery.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 06/11/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPPoint.h"

NS_ASSUME_NONNULL_BEGIN

/**
Query object used when making a request to `MPLocationService`.
*/
@interface MPQuery : NSObject


/**
 List of properties that `MPLocationService` will take into account when finding and sorting matching locations. By default, `MPLocationService` will search in the name, roomId and aliases properties. Possible other properties depend on the location content. E.g. if an `MPLocation` has a field called `booking-id`, the string "booking-id" (case-sensitive) may be added. Query properties added that does not exist in any locations will be ignored.
 */
@property (nonatomic) NSArray<NSString*>* queryProperties;

/**
 Single line search string.
 */
@property (nonatomic) NSString* query;

/**
 Geographical point that serve as additional proximity context for a search. If supplied, locations that is closer to the `near` point will be ranked higher. Locations that have a low rank in other regards will not gain from this.
 */
@property (nonatomic) MPPoint* near;

// Later implementation MISDKIOS-273
//- (void) addOrderingWithProperty:(NSString*) property ascending: (BOOL) ascending;
//- (void) setOrderingWithProperty:(NSString*) property ascending: (BOOL) ascending;

@end

NS_ASSUME_NONNULL_END
