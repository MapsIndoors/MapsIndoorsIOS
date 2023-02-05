//
//  MPLoggingConfig+JSON.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 02/02/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import "MPLoggingConfig.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPLoggingConfig (JSON)

- (instancetype) initWithJsonDictionary:(NSDictionary*)dict;

@end

NS_ASSUME_NONNULL_END
