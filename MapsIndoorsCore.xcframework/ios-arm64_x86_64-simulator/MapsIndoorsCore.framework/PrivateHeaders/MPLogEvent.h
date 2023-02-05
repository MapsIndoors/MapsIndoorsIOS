//
//  MPLogEvent.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 15/02/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#ifndef MPLogEvent_h
#define MPLogEvent_h

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
typedef NS_ENUM(int, MPLogDomain) {
    MPLogDomainAppLifeTime,
    MPLogDomainConfiguration,
    MPLogDomainSearch,
    MPLogDomainDirections,
    MPLogDomainLiveData,
    MPLogDomainMap,
    MPLogDomainLocationSources,
    MPLogDomainDatasetManager
};

#define MPLogDomainString(enum) @{   \
    @(MPLogDomainAppLifeTime): @"app_life_time", \
    @(MPLogDomainConfiguration): @"configuration", \
    @(MPLogDomainSearch): @"search", \
    @(MPLogDomainDirections): @"directions", \
    @(MPLogDomainLiveData): @"live_data", \
    @(MPLogDomainMap): @"map", \
    @(MPLogDomainLocationSources): @"location_sources", \
    @(MPLogDomainDatasetManager): @"dataset_manager" \
}[@(enum)]\

typedef NS_ENUM(int, MPLogEvent) {
    MPLogEventEnteredForeground,
    MPLogEventEnteredBackground,
    MPLogEventSdkLoaded,
    MPLogEventMapInstantiated,
    MPLogEventLanguageChanged,
    MPLogEventOfflineModeChanged,
    MPLogEventSearchPerformed,
    MPLogEventDirectionsRequested,
    MPLogEventDirectionsRendered,
    MPLogEventSubscriptionStarted,
    MPLogEventSubscriptionStopped,
    MPLogEventLivedataEnabledForMap,
    MPLogEventMapClicked,
    MPLogEventClusteringModeChanged,
    MPLogEventLocationSourcesRegistered,
    MPLogEventDatasetAdded,
    MPLogEventDatasetRemoved,
    MPLogEventDatasetSynchronized
};

#define MPLogEventString(enum) @{   \
    @(MPLogEventEnteredForeground): @"entered_foreground", \
    @(MPLogEventEnteredBackground): @"entered_background", \
    @(MPLogEventSdkLoaded): @"sdk_loaded", \
    @(MPLogEventMapInstantiated): @"map_instantiated", \
    @(MPLogEventLanguageChanged): @"language_changed", \
    @(MPLogEventOfflineModeChanged): @"offline_mode_changed", \
    @(MPLogEventSearchPerformed): @"search_performed", \
    @(MPLogEventDirectionsRequested): @"directions_requested", \
    @(MPLogEventDirectionsRendered): @"directions_rendered", \
    @(MPLogEventSubscriptionStarted): @"subscription_started", \
    @(MPLogEventSubscriptionStopped): @"subscription_stopped", \
    @(MPLogEventLivedataEnabledForMap): @"livedata_enabled_for_map", \
    @(MPLogEventMapClicked): @"map_clicked", \
    @(MPLogEventClusteringModeChanged): @"clustering_mode_changed", \
    @(MPLogEventLocationSourcesRegistered): @"location_sources_registered", \
    @(MPLogEventDatasetAdded): @"dataset_added", \
    @(MPLogEventDatasetRemoved): @"dataset_removed", \
    @(MPLogEventDatasetSynchronized): @"dataset_synchronized" \
}[@(enum)]\

#endif /* MPLogEvent_h */
