//
//  MPFloor.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 1/13/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"
@import MapsIndoors;

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Floor data model. Holds the floor geometry, display name, z-index and id of the building it belongs to.
 */
@interface MPFloorInternal : JSONModel <MPFloor>

/// Floor id
@property (nonatomic, copy, nonnull) NSString* floorId;
/**
 Floor layer style, if any.
 */
@property (nonatomic, copy, nullable) NSString* style;
/// Floor index
@property (nonatomic, strong, nullable) NSNumber* floorIndex;
@property (nonatomic, copy, nullable) NSString* buildingId;
/// Floor name
@property (nonatomic, copy, nullable) NSString* name;
/// Floor aliases
@property (nonatomic, copy, nullable) NSArray<NSString *>* aliases;

@end
