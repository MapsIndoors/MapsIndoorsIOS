//
//  MPLocationUpdate+Private.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 03/12/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//


#import "MPLocationUpdate.h"
#import "MPLocationField.h"

@class MPLocationDisplayRule;

NS_ASSUME_NONNULL_BEGIN

@interface MPLocationUpdate (Private)

@property (atomic, nullable) NSMutableArray<NSString*>* categories;
@property (atomic, nullable) NSMutableArray<MPLocationField*>* properties;
@property (atomic, nullable) MPLocation* prototypeLocation;

@end

NS_ASSUME_NONNULL_END
