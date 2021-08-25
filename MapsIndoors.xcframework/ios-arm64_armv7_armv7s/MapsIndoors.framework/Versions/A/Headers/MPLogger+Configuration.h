//
//  MPLogger+Configuration.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 03/02/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import "MPLogger.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPLogger (Configuration)

@property (nonatomic, strong, readwrite) MPLoggingConfig* configuration;

@end

NS_ASSUME_NONNULL_END
