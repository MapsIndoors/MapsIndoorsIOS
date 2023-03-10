//
//  MPBackendDetails+JSONConversion.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 13/10/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import "MPBackendDetails.h"
#import "MPAuthClientInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPBackendDetails (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
@end

@interface MPAuthClientInfo (JSONConversion)
+ (instancetype)fromJSONDictionary:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
