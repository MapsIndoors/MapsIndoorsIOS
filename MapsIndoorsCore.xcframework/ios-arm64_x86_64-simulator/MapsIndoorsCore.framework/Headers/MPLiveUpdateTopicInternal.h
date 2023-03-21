//
//  MPLiveStateItemPath.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 16/06/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapsIndoors;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// Topic model for a Live Update. A Live Update Topic is hierarchical in the way it is defined, and its relation to MapsIndoors data is derivable by its 7 components: Dataset, Venue, Building, Floor, Room, Location and Domain Type
/// > Warning: [INTERNAL - DO NOT USE]
@interface MPLiveUpdateTopicInternal : NSObject<MPLiveUpdateTopic>

/// Get the id of the Dataset related to this topic
@property (nonatomic, copy, readonly) NSString *datasetId;
/// Get the id of the Venue related to this topic if any
@property (nonatomic, copy, readonly, nullable) NSString *venueId;
/// Get the id of the Building related to this topic if any
@property (nonatomic, copy, readonly, nullable) NSString *buildingId;
/// Get the id of the Floor related to this topic if any
@property (nonatomic, copy, readonly, nullable) NSString *floorId;
/// Get the id of the Room related to this topic if any
@property (nonatomic, copy, readonly, nullable) NSString *roomId;
/// Get the id of the Location related to this topic if any
@property (nonatomic, copy, readonly, nullable) NSString *locationId;
/// Get the Domain Type related to this topic if any
@property (nonatomic, copy, readonly, nullable) NSString *domainType;

- (nonnull instancetype)initWithTopic:(NSString * _Nonnull)topic;

@end

NS_ASSUME_NONNULL_END
