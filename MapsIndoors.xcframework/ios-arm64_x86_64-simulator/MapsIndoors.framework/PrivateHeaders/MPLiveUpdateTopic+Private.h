//
//  MPLiveUpdateTopic+Private.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 06/08/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPLiveUpdateTopic.h"

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, MPTopicIdx) {
    MPTopicIdxDataset = 0,
    MPTopicIdxVenue = 1,
    MPTopicIdxBuilding = 2,
    MPTopicIdxFloor = 3,
    MPTopicIdxRoom = 4,
    MPTopicIdxLocation = 5,
    MPTopicIdxDomainType = 6,
    MPTopicIdxCount = 7,
};

@interface MPLiveUpdateTopic (Private)

- (instancetype)initWithJsonDictionary:(NSDictionary<NSString *, id<NSObject>> *)dictionary;
- (nullable instancetype)initWithJsonValue:(nullable id<NSObject>)jsonValue;

@property (nonatomic, strong, readwrite, nullable) NSString *buildingId;
@property (nonatomic, strong, readwrite) NSString *datasetId;
@property (nonatomic, strong, readwrite, nullable) NSString *floorId;
@property (nonatomic, strong, readwrite, nullable) NSString *roomId;
@property (nonatomic, strong, readwrite, nullable) NSString *venueId;
@property (nonatomic, strong, readwrite, nullable) NSString *locationId;
@property (nonatomic, strong, readwrite, nullable) NSString *domainType;

@property (nonatomic, strong, readonly) NSString *topicStringUrlEscaped;

+ (MPLiveUpdateTopic*) building:(NSString*)buildingId;
+ (MPLiveUpdateTopic*) dataset:(NSString*)datasetId;
+ (MPLiveUpdateTopic*) floor:(NSString*)floorId;
+ (MPLiveUpdateTopic*) room:(NSString*)roomId;
+ (MPLiveUpdateTopic*) venue:(NSString*)venueId;
+ (MPLiveUpdateTopic*) location:(NSString*)locationId;
+ (MPLiveUpdateTopic*) domainType:(NSString*)domainType;

- (MPLiveUpdateTopic*) building:(NSString*)buildingId;
- (MPLiveUpdateTopic*) dataset:(NSString*)datasetId;
- (MPLiveUpdateTopic*) floor:(NSString*)floorId;
- (MPLiveUpdateTopic*) room:(NSString*)roomId;
- (MPLiveUpdateTopic*) venue:(NSString*)venueId;
- (MPLiveUpdateTopic*) location:(NSString*)locationId;
- (MPLiveUpdateTopic*) domainType:(NSString*)domainType;

@end

NS_ASSUME_NONNULL_END
