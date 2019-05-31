//
//  MPFilter.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 06/11/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPMapExtend.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPFilter : NSObject

/**
 Categories filter. List of category keys as in `MPLocation.categories.allKeys`. If multiple categories are supplied the filter will OR'ed, meaning if a location belongs to at least one of the categories it will be considered as a match.
 */
@property NSArray<NSString*>* categories;


/**
 Rectangular geographical bounds filter.
 */
@property MPMapExtend* bounds;

/**
 List of location ids that is hierarchially considered as a parent of other locations.
 Venues are a parents of Buildings and other Locations (mainly outdoor locations).
 Buildings are parents of Floors.
 Floors are parents of Rooms and other Locations.
 */
@property NSArray<NSString*>* parents;
/**
 Limit number of locations in the result.
 */
@property NSUInteger take;

/**
 Skip locations in the result, e.g. for pagination.
 */
@property NSUInteger skip;

/**
 Filter by floor index. Note that there is a difference between the displayed floor name (e.g. "LG") and the index (e.g. -1).
 */
@property (nullable) NSNumber* floor;

@end

NS_ASSUME_NONNULL_END
