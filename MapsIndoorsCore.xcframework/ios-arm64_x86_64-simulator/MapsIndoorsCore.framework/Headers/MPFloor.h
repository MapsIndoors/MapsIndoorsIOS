//
//  MPFloor.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 1/13/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"
#import "MPGeometry.h"

/**
 Floor data model. Holds the floor geometry, display name, z-index and id of the building it belongs to.
 */
@interface MPFloor : JSONModel

/// Floor id
@property (nonatomic, strong, nonnull, readonly) NSString* floorId;
/**
 Floor layer style, if any.
 */
@property (nonatomic, strong, nullable, readonly) NSString* style;
/// Floor index
@property (nonatomic, strong, nullable, readonly) NSNumber* floorIndex;
@property (nonatomic, strong, nullable, readonly) NSString* buildingId;
/// Floor bounds
@property (nonatomic, strong, nullable, readonly) NSArray<NSArray*>* bounds;
/// Floor name
@property (nonatomic, strong, nullable, readonly) NSString* name;
/// Floor aliases
@property (nonatomic, strong, nullable, readonly) NSArray<NSString *>* aliases;

@end
