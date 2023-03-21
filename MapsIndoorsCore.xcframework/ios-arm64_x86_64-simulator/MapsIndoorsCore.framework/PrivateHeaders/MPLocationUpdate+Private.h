//
//  MPLocationUpdate+Private.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 03/12/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//


#import "MPLocationUpdate.h"
@import MapsIndoors;

@protocol MPLocationFieldInternal;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPLocationUpdate (Private)

@property (atomic, nullable) NSMutableArray<NSString*>* categories;
@property (atomic, nullable) NSMutableArray<id<MPLocationField>><MPLocationFieldInternal>* properties;
@property (atomic, nullable) id<MPLocation> prototypeLocation;

@end

NS_ASSUME_NONNULL_END
