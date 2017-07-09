//
//  MPBuildingDataset.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 9/9/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import "MPJSONModel.h"
#import "MPBuilding.h"

/**
 Collection of buildings with some retrieval and calculation functionality.
 */
@interface MPBuildingDataset : MPJSONModel
/**
 The type of data (equals "FeatureCollection").
 */
@property NSString* type;
/**
 Array of buildings contained in the collection.
 */
@property NSArray* features;
/**
 Retrieve a building by its unique shortname.
 @param  The shortname of the building
 */
- (MPBuilding*) getBuilding: (NSString*) shortName;
/**
 Assign a delegate object to all buildings in the collection, this object will hold the onBuildingReady:shortName event method.
 @param  The delegate object
 */
- (void) setBuildingDelegate: (NSObject<MPBuildingDelegate>*) delegate;
/**
 Get the intersection area on two GMSCoordinateBounds.
 @param  b1 Some coordinate bounds (Typically the current map viewport bounds)
 @param  b2 Some other coordinate bounds (Typically building bounds)
 */
- (double) intersectionAreaBetweenBounds: (GMSCoordinateBounds*) b1 andBounds: (GMSCoordinateBounds*) b2;
@end
