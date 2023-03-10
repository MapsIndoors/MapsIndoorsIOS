//
//  MPFilter+Private.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 06/11/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "MPFilter.h"

@class MIFilter;

NS_ASSUME_NONNULL_BEGIN

@interface MPFilter (Private)

@property (nonatomic) BOOL                  ignoreLocationSearchableStatus;     //! Make queries return location-results that are marked as non-searchable.
@property (nonatomic) BOOL                  ignoreLocationActiveStatus;         //! Make queries return location-results that are marked as inactive using the active from/to mechanism.
@property (nonatomic, readonly) MIFilter*   miFilter;

@end


NS_ASSUME_NONNULL_END
