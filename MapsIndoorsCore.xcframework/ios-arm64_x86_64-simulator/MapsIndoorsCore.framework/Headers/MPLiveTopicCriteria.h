//
//  MPLiveTopicCriteria.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 06/08/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "MPLiveUpdateTopic.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// Live Topic Criteria model used for subscriptions to Live Updates using MPLiveDataManager.
/// A Live Topic Criteria is hierarchical in the way it is defined, and its relation to MapsIndoors data is derivable by its 7 components: Dataset, Venue, Building, Floor, Room, Location and Domain Type.
/// All properties can be left out but datasetId will then default to the currently active dataset.
/// > Warning: [INTERNAL - DO NOT USE]
@interface MPLiveTopicCriteria : MPLiveUpdateTopic

/// Initialise a Topic Criteria with given Dataset id.
/// @param datasetId The Dataset id
+ (MPLiveTopicCriteria*) dataset:(NSString*)datasetId;
/// Initialise a Topic Criteria with given Venue id.
/// @param venueId The Venue id.
+ (MPLiveTopicCriteria*) venue:(NSString*)venueId;
/// Initialise a Topic Criteria with given Building id.
/// @param buildingId The Building id.
+ (MPLiveTopicCriteria*) building:(NSString*)buildingId;
/// Initialise a Topic Criteria with given Floor id.
/// @param floorId The Floor id.
+ (MPLiveTopicCriteria*) floor:(NSString*)floorId;
/// Initialise a Topic Criteria with given Room id.
/// @param roomId The Room id.
+ (MPLiveTopicCriteria*) room:(NSString*)roomId;
/// Initialise a Topic Criteria with given Location id.
/// @param locationId The Location id.
+ (MPLiveTopicCriteria*) location:(NSString*)locationId;
/// Initialise a Topic Criteria with given Domain Type.
/// @param domainType The Domain Type.
+ (MPLiveTopicCriteria*) domainType:(NSString*)domainType;

/// Get Topic Criteria with given Dataset id changed.
/// @param datasetId The Dataset id
- (MPLiveTopicCriteria*) dataset:(NSString*)datasetId;
/// Get Topic Criteria with given Venue id changed.
/// @param venueId The Venue id.
- (MPLiveTopicCriteria*) venue:(NSString*)venueId;
/// Get Topic Criteria with given Building id changed.
/// @param buildingId The Building id.
- (MPLiveTopicCriteria*) building:(NSString*)buildingId;
/// Get Topic Criteria with given Floor id changed.
/// @param floorId The Floor id.
- (MPLiveTopicCriteria*) floor:(NSString*)floorId;
/// Get Topic Criteria with given Room id changed.
/// @param roomId The Room id.
- (MPLiveTopicCriteria*) room:(NSString*)roomId;
/// Get Topic Criteria with given Location id changed.
/// @param locationId The Location id.
- (MPLiveTopicCriteria*) location:(NSString*)locationId;
/// Get Topic Criteria with given Domain Type changed.
/// @param domainType The Domain Type.
- (MPLiveTopicCriteria*) domainType:(NSString*)domainType;

@end

NS_ASSUME_NONNULL_END
