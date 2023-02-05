//
//  MPGeometry+Mutable.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 23/08/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import "MPGeometry.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPGeometry ()

@property (nonatomic, strong, nullable, readwrite) NSString<Optional>*   type;
@property (nonatomic, strong, nullable, readwrite) NSArray *coordinates;
@property (nonatomic, strong, nullable, readwrite) NSArray<NSNumber*><Optional>*    bbox;

@end

NS_ASSUME_NONNULL_END
