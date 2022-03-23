//
//  MPLiveUpdate+Private.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 07/08/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "MPLiveUpdate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPLiveUpdate (Private)

/// Get the data properties of the Live Update as key/value pairs.
@property (nonatomic, strong, readwrite) NSDictionary<NSString*, id> *properties;

+ (MPLiveUpdate*)liveUpdateWithDictionary:(NSDictionary<NSString *, id<NSObject>> *)dictionary topic:(nullable NSString*)topic;
- (instancetype)initWithJsonDictionary:(NSDictionary<NSString *, id> *)dict topicObject:(MPLiveUpdateTopic*)topic;
- (instancetype)initWithJsonDictionary:(NSDictionary<NSString *, id<NSObject>> *)dictionary topic:(nullable NSString*)topic;
- (nullable instancetype)initWithJsonValue:(nullable id<NSObject>)jsonValue topic:(nullable NSString*)topic;

@end

NS_ASSUME_NONNULL_END
