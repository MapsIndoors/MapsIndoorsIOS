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
@property (nonatomic, strong, nullable) NSString* type;
/**
 Array of buildings contained in the collection.
 */
@property (nonatomic, strong, nullable)NSArray* features;
/**
 Retrieve a building by its unique shortname.
 @param shortName The shortname of the building
 */
- (nullable MPBuilding*) getBuilding: (nonnull NSString*) shortName;
/**
 Assign a delegate object to all buildings in the collection, this object will hold the onBuildingReady:shortName event method.
 @param delegate The delegate object
 */
- (void) setBuildingDelegate: (nullable NSObject<MPBuildingDelegate>*) delegate;

@end
