//
//  MPLocationDataset.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 7/29/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"
@import MapsIndoors;

NS_ASSUME_NONNULL_BEGIN

@protocol MPLocationInternal;

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Dataset that holds locations, searched results and a filter.
 */
@interface MPLocationDataset : JSONModel

- (instancetype)initWithLocations:(NSArray<id<MPLocation>><MPLocationInternal>*) locations;

/**
 Main location array in the data set.
 */
@property (nonatomic, strong, nullable, readonly) NSArray<id<MPLocation>><MPLocationInternal> *list;

@end

NS_ASSUME_NONNULL_END
