//
//  MPSubscriptionTopic.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 18/02/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MPSubscriptionTopic <NSObject>

- (instancetype)initWithTopicString:(NSString*)topic;
@property (nonatomic, strong, readonly) NSString *topicString;

@end

NS_ASSUME_NONNULL_END
