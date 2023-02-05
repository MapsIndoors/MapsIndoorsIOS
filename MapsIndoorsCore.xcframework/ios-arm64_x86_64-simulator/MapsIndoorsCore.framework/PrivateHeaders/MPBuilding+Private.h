//
//  MPBuilding+Private.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 08/09/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//


#import "MPMutableLocation.h"
#import "MPBuilding.h"


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPBuilding (Private)



- (NSArray<MPMutableLocation*>*_Nullable) getLocationsForBuildingAndFloors;

/**
 Get the MPLocation object that corresponds to this MPBuilding object.
 */
@property (nonatomic, strong, readonly, nonnull) MPLocation*    asLocationObject;


@end
