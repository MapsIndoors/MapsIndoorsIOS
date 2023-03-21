//
//  MPLiveUpdate+Private.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 07/08/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "MPLiveUpdateInternal.h"
#import "MPLiveUpdateTopicInternal.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPLiveUpdateInternal (Private)

/// Get the data properties of the Live Update as key/value pairs.
@property (nonatomic, strong, readwrite) NSDictionary<NSString*, id> *properties;

+ (MPLiveUpdateInternal*)liveUpdateWithDictionary:(NSDictionary<NSString *, id<NSObject>> *)dictionary topic:(nullable NSString*)topic;
- (instancetype)initWithJsonDictionary:(NSDictionary<NSString *, id> *)dict topicObject:(MPLiveUpdateTopicInternal*)topic;
- (instancetype)initWithJsonDictionary:(NSDictionary<NSString *, id<NSObject>> *)dictionary topic:(nullable NSString*)topic;
- (nullable instancetype)initWithJsonValue:(nullable id<NSObject>)jsonValue topic:(nullable NSString*)topic;

@end

NS_ASSUME_NONNULL_END
