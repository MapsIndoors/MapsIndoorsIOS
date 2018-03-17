//
//  MPLocations.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 7/29/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPLocation.h"

/**
 Empty protocol specification
 */
@protocol MPLocation
@end

/**
 Dataset that holds locations, searched results and a filter.
 */
@interface MPLocationDataset : MPJSONModel
/**
 Main location array in the data set.
 */
@property (nonatomic, strong) NSArray<MPLocation*><MPLocation> *list;
/**
 Array to hold filtered results in the data set.
 */
@property (nonatomic, strong) NSArray<Optional> *searchResult DEPRECATED_ATTRIBUTE;
/**
 String used as text filter.
 */
@property (nonatomic, strong) NSArray<Optional> *categories DEPRECATED_ATTRIBUTE;

- (NSArray*)filterByName:(NSString*)name DEPRECATED_ATTRIBUTE;
- (NSArray*)filterByName:(NSString*)name andCategories:(NSArray*)categories DEPRECATED_ATTRIBUTE;

@end
