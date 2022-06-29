//
//  MPBuildingCollection.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 21/10/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

@import JSONModel;
#import "MPBuilding.h"


@interface MPBuildingCollection : JSONModel

@property (nonatomic, strong, nullable) NSArray<MPBuilding*><MPBuilding>* buildings;

@end
