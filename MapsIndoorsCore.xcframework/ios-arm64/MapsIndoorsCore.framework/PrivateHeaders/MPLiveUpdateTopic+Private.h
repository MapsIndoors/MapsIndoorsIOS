//
//  MPLiveUpdateTopic+Private.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 06/08/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPLiveUpdateTopicInternal.h"

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

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPLiveUpdateTopicInternal (Private)

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

+ (MPLiveUpdateTopicInternal*) building:(NSString*)buildingId;
+ (MPLiveUpdateTopicInternal*) dataset:(NSString*)datasetId;
+ (MPLiveUpdateTopicInternal*) floor:(NSString*)floorId;
+ (MPLiveUpdateTopicInternal*) room:(NSString*)roomId;
+ (MPLiveUpdateTopicInternal*) venue:(NSString*)venueId;
+ (MPLiveUpdateTopicInternal*) location:(NSString*)locationId;
+ (MPLiveUpdateTopicInternal*) domainType:(NSString*)domainType;

- (MPLiveUpdateTopicInternal*) building:(NSString*)buildingId;
- (MPLiveUpdateTopicInternal*) dataset:(NSString*)datasetId;
- (MPLiveUpdateTopicInternal*) floor:(NSString*)floorId;
- (MPLiveUpdateTopicInternal*) room:(NSString*)roomId;
- (MPLiveUpdateTopicInternal*) venue:(NSString*)venueId;
- (MPLiveUpdateTopicInternal*) location:(NSString*)locationId;
- (MPLiveUpdateTopicInternal*) domainType:(NSString*)domainType;

@end

NS_ASSUME_NONNULL_END
