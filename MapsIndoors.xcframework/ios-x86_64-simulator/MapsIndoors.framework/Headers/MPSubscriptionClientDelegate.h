//
//  MPSubcriptionClientDelegate.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 27/07/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPSubscriptionState.h"
#import "MPSubscriptionTopic.h"

NS_ASSUME_NONNULL_BEGIN


@protocol MPSubscriptionClientDelegate <NSObject>

@required
- (void) didReceiveMessage:(NSData*)message onTopic:(NSString*) topicString;

@required
- (void) didUpdateState:(MPSubscriptionState)state;

@required
- (void) didSubscribe:(id<MPSubscriptionTopic>)topic;

@required
- (void) didUnsubscribe:(id<MPSubscriptionTopic>)topic;

@required
- (void) onSubscriptionError:(NSError*)error topic:(id<MPSubscriptionTopic>)topic;

@required
- (void) onUnsubscriptionError:(NSError*)error topic:(id<MPSubscriptionTopic>)topic;

@required
- (void) onError:(NSError*)error;

@end

NS_ASSUME_NONNULL_END
