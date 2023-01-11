//
//  MPAppData+Private.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 31/01/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//

#import "MPAppData.h"

NS_ASSUME_NONNULL_BEGIN

@class MPLoggingConfig;

@interface MPAppData (Private)

@property (nonatomic, strong, nullable, readwrite) MPLoggingConfig* loggingConfig;

@end

NS_ASSUME_NONNULL_END
