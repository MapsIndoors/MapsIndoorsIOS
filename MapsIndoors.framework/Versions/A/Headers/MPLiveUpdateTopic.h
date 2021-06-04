//
//  MPLiveStateItemPath.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 16/06/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class MPLiveTopicCriteria;


/// Topic model for a Live Update. A Live Update Topic is hierarchical in the way it is defined, and its relation to MapsIndoors data is derivable by its 7 components: Dataset, Venue, Building, Floor, Room, Location and Domain Type
@interface MPLiveUpdateTopic : NSObject

/// Initialises a Topic with a 7-component path formatted string, for example "datasetId/venueId/buildingId/floorId/roomId/locationId/domainType"
/// @param topic The topic string
- (instancetype)initWithTopicString:(NSString*)topic;

/// Get the id of the Dataset related to this topic
@property (nonatomic, strong, readonly) NSString *datasetId;
/// Get the id of the Venue related to this topic if any
@property (nonatomic, strong, readonly, nullable) NSString *venueId;
/// Get the id of the Building related to this topic if any
@property (nonatomic, strong, readonly, nullable) NSString *buildingId;
/// Get the id of the Floor related to this topic if any
@property (nonatomic, strong, readonly, nullable) NSString *floorId;
/// Get the id of the Room related to this topic if any
@property (nonatomic, strong, readonly, nullable) NSString *roomId;
/// Get the id of the Location related to this topic if any
@property (nonatomic, strong, readonly, nullable) NSString *locationId;
/// Get the Domain Type related to this topic if any
@property (nonatomic, strong, readonly, nullable) NSString *domainType;


/// Method to determine whether a Live Update Topic qualifies for a given Topic Criteria
/// @param criteria The Topic Criteria
- (BOOL) matchesCriteria:(MPLiveTopicCriteria*)criteria;

@end

NS_ASSUME_NONNULL_END
