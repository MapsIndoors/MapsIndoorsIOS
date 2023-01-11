//
//  MPFloor+Private.h
//  MapsIndoorsTests
//
//  Created by Daniel Nielsen on 20/08/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import "MPFloor.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPFloor ()

@property (nonatomic, strong, nullable, readwrite) NSNumber<Optional>* floorIndex;
@property (nonatomic, strong, nonnull, readwrite) NSString* floorId;
@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* style;
@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* buildingId;
@property (nonatomic, strong, nullable, readwrite) NSArray<NSArray*>* bounds;
@property (nonatomic, strong, nullable, readwrite) NSString* name;
@property (nonatomic, strong, nullable, readwrite) NSArray<NSString *><Optional>* aliases;

@end

NS_ASSUME_NONNULL_END
