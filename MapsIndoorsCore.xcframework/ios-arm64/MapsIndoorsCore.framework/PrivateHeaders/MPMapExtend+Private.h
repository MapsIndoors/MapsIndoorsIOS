//
//  MPMapExtend+Private.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 06/11/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "MPMapExtend.h"
#import "MICoordinateBounds.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPMapExtend (Private)

@property (nonatomic, readonly) MICoordinateBounds* miBounds;

@end

NS_ASSUME_NONNULL_END
