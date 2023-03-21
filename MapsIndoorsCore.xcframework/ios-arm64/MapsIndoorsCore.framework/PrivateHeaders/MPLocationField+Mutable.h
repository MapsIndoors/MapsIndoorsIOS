//
//  MPLocationField+Mutable.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 23/08/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import "MPLocationFieldInternal.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPLocationFieldInternal ()

@property (nonatomic, copy, readwrite) NSString* type;
@property (nonatomic, copy, readwrite) NSString* text;
@property (nonatomic, copy, nullable, readwrite) NSString* value;

@end

NS_ASSUME_NONNULL_END
