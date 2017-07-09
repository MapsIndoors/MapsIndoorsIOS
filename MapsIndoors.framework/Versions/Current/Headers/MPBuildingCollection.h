//
//  MPBuildingCollection.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 21/10/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import "MPJSONModel.h"

@protocol MPBuilding
@end

@interface MPBuildingCollection : MPJSONModel

@property NSArray<MPBuilding>* buildings;

@end
