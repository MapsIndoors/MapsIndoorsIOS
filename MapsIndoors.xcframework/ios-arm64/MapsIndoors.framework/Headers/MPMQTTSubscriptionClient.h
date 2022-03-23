//
//  MPMQTTSubscriptionClient.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 27/07/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPSubscriptionClient.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPMQTTSubscriptionClient : NSObject<MPSubscriptionClient>

@property (nonatomic, weak) id<MPSubscriptionClientDelegate> delegate;
@property (nonatomic) MPSubscriptionState state;

@end

NS_ASSUME_NONNULL_END
