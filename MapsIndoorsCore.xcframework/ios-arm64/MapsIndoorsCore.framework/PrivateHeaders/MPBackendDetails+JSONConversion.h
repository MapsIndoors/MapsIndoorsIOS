//
//  MPBackendDetails+JSONConversion.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 13/10/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import "MPBackendDetails.h"
#import "MPAuthClientInfoInternal.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPBackendDetails (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
@end
/// > Warning: [INTERNAL - DO NOT USE]
@interface MPAuthClientInfoInternal (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
