//
//  MPLocations.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 7/29/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPLocation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 Empty protocol specification
 */
@protocol MPLocation
@end

/**
 Dataset that holds locations, searched results and a filter.
 */
@interface MPLocationDataset : JSONModel

- (instancetype)initWithLocations:(NSArray<MPLocation*>*) locations;

/**
 Main location array in the data set.
 */
@property (nonatomic, strong, nullable, readonly) NSArray<MPLocation*><MPLocation> *list;

@end

NS_ASSUME_NONNULL_END
