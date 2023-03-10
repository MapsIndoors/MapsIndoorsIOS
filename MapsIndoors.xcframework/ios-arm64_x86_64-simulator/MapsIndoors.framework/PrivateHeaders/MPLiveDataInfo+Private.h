//
//  MPLiveDataInfo+Private.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 14/12/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "MPLiveDataInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPLiveDataInfo (Private)

+ (MPLiveDataInfo*)newWithJsonDictionary:(NSDictionary<NSString *, id> *)dict;

@end

NS_ASSUME_NONNULL_END
