//
//  MPMapExtend+Private.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 06/11/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "MPMapExtend.h"

@class MICoordinateBounds;

NS_ASSUME_NONNULL_BEGIN

@interface MPMapExtend (Private)

@property (nonatomic, readonly) MICoordinateBounds* miBounds;

@end

NS_ASSUME_NONNULL_END
