//
//  MPBuilding+Mutable.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 23/08/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import "MPBuilding.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPBuilding ()

@property (nonatomic, strong, nullable, readwrite) NSNumber* currentFloor;
@property (nonatomic, strong, nullable, readwrite) NSString* externalId;
@property (nonatomic, strong, nullable, readwrite) NSString* buildingId;
@property (nonatomic, strong, nullable, readwrite) NSString* address;
@property (nonatomic, strong, nullable, readwrite) NSString* administrativeId;
@property (nonatomic, strong, nullable, readwrite) NSMutableDictionary<NSString*, MPFloor*><MPFloor>* floors;
@property (nonatomic, strong, nullable, readwrite) NSString* name;
@property (nonatomic, strong, nullable, readwrite) MPPoint* anchor;
@property (nonatomic, strong, nullable, readwrite) NSArray<NSArray*>* bounds;
@property (nonatomic, strong, nullable, readwrite) NSNumber* defaultFloor;
@property (nonatomic, strong, nullable, readwrite) NSString* venueId;
@property (nonatomic, strong, nullable, readwrite) NSMutableDictionary<NSString*, MPLocationField*><MPLocationField> *properties;

@end

NS_ASSUME_NONNULL_END
