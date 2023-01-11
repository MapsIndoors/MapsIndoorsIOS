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

/**
Filter object used when making a request to `MPLocationService`. The filters will be applied in the following order:
 1. Bounds filter
 2. Locations filter
 3. Floor index filter
 4. Categories filter
 5. Types filter
 6. Parents and depth filter
 7. Take filter
 8. Skip filter
 Locations must pass all filters to be part of the result.
*/
@interface MPFilter : NSObject

/**
 Locations filter. List of location ids as in `MPLocation.locationId`. If multiple locations are supplied the filter will OR'ed.
 */
@property (nonatomic, strong) NSArray<NSString*>* locations;

/**
 Types filter. List of type names as in `MPLocation.type`. If multiple types are supplied the filter will OR'ed, meaning if a location belongs to at least one of the types it will be considered as a match.
 */
@property (nonatomic, strong) NSArray<NSString*>* types;

/**
 Categories filter. List of category keys as in `MPLocation.categories.allKeys`. If multiple categories are supplied the filter will OR'ed, meaning if a location belongs to at least one of the categories it will be considered as a match.
 */
@property (nonatomic, strong) NSArray<NSString*>* categories;

/**
 Rectangular geographical bounds filter.
 */
@property (nonatomic, strong) MPMapExtend* bounds;

/**
 List of location ids that is hierarchially considered as a parent of other locations.
 Venues are a parents of Buildings and other Locations (mainly outdoor locations).
 Buildings are parents of Floors.
 Floors are parents of Rooms and other Locations.
 */
@property (nonatomic, strong) NSArray<NSString*>* parents;
/**
 Limit number of locations in the result.
 */
@property (nonatomic) NSUInteger take;

/**
 Skip locations in the result, e.g. for pagination.
 */
@property (nonatomic) NSUInteger skip;

/**
 * The depth property makes it possible to get the n'th descendant of a parent location. ;
 * Thus, the depth property only applies to filters that has set one or more parents. ;
 * The hierarchial tree of data is generally structured as Venue > Building > Floor > Room > POI.;
 * For example, this means that a Floor is the 1st descendant of a Building. ;
 * So to get all locations inside a Building, set the depth to 3.;
 * The default value is 1, giving you only the immediate descendant of the specified parents.;
 */
@property NSUInteger depth;

/**
 Filter by floor index. Note that there is a difference between the displayed floor name (e.g. "LG") and the index (e.g. -1).
 */
@property (nonatomic, strong, nullable) NSNumber* floorIndex;

@end

NS_ASSUME_NONNULL_END
