//
//  MPBuilding+Private.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 08/09/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "MPBuildingInternal.h"


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPBuildingInternal (Private)

- (NSArray<id<MPLocation>>* _Nullable) getLocationsForBuildingAndFloors;

/**
 Get the MPLocation object that corresponds to this MPBuilding object.
 */
@property (nonatomic, strong, readonly, nonnull) id<MPLocation> asLocationObject;

@end
