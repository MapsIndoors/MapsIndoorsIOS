//
//  MPWirelessPositionTopic.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 18/02/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPSubscriptionTopic.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPWirelessPositionTopic : NSObject<MPSubscriptionTopic>

- (instancetype)initWithTenantId:(NSString*)tenantId deviceId:(NSString*)deviceId;

@end

NS_ASSUME_NONNULL_END
