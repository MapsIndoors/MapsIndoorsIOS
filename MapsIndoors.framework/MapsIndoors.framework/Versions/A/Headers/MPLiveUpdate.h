//
//  MPLiveStateItem.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 16/06/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MPLiveUpdateTopic;

NS_ASSUME_NONNULL_BEGIN

/// Model for a Live Update. Used in MPLiveDataManagerDelegate and MPLocation::getLiveUpdate().
@interface MPLiveUpdate : NSObject

/// Get the Topic of the Live Update.
@property (nonatomic, strong, readonly) MPLiveUpdateTopic *topic;
/// Get the item id that a Live Update relates to. In most cases this would be the id of a MPLocation.
@property (nonatomic, strong, readonly) NSString *itemId;
/// Get the id for the origin source entity of a Live Update. Often the Live Update comes from another entity or device in a 3rd-party system. For example an id of a meeting room calendar in a booking system or an id of a room temperature sensor.
@property (nonatomic, strong, readonly) NSString *originSourceId;
/// Get the timestamp for a Live Update.
@property (nonatomic, strong, readonly) NSString *timestamp;
/// Get a value from a specific Live Update property. If no value exists the method returns nil.
/// @param key The key for the property.
- (nullable NSObject*) getLiveValueForKey:(NSString*)key;

@end
NS_ASSUME_NONNULL_END
