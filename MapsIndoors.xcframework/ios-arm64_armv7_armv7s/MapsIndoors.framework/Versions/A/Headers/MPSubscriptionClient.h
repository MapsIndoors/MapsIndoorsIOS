//
//  MPSubscriptionClient.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 27/07/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPSubscriptionClientDelegate.h"
#import "MPSubscriptionState.h"
#import "MPSubscriptionTopic.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MPSubscriptionClient <NSObject>

@property (nonatomic, weak) id<MPSubscriptionClientDelegate> delegate;
@property (nonatomic) MPSubscriptionState state;

- (void) connect:(BOOL)cleanSessionFlag;
- (void) disconnect;

- (void) subscribe:(id<MPSubscriptionTopic>)topic;
- (void) unsubscribe:(id<MPSubscriptionTopic>)topic;

@end

NS_ASSUME_NONNULL_END
