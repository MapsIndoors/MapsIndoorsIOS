//
//  MPFilter+Private.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 06/11/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "MIFilter.h"
@import MapsIndoors;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPFilter (Private)

@property (nonatomic) BOOL                  ignoreLocationSearchableStatus;     //! Make queries return location-results that are marked as non-searchable.
@property (nonatomic) BOOL                  ignoreLocationActiveStatus;         //! Make queries return location-results that are marked as inactive using the active from/to mechanism.
@property (nonatomic, readonly) MIFilter*   miFilter;

@end

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPFilter (Override)

@end

NS_ASSUME_NONNULL_END
