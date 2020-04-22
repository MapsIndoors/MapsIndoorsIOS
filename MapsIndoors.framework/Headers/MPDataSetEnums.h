//
//  MPDataSetScope.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 31/01/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#ifndef MPDataSetEnums_h
#define MPDataSetEnums_h

/**
Data set caching scope. Currently only a full cache (non-partial) scope is supported (basic and detailed scope will sync full dataset)
*/
typedef NS_ENUM(NSUInteger, MPDataSetCacheScope) {
    MPDataSetCachingScope_Basic,        //! Basic cache scope. Information about locations, buildings and venue and type images.
    MPDataSetCachingScope_Detailed,     //! Basic + location-specific images.
    MPDataSetCachingScope_Full,         //! Full cache scope. All necessary content is downloaded for a data set to work offline.

    MPDataSetCachingScope_Default = MPDataSetCachingScope_Basic
};

/**
Data set caching strategy.
*/
typedef NS_ENUM(NSUInteger, MPDataSetCachingStrategy) {
    /**
    Don't cache. Data will be removed at any point after usage.
    */
    MPDataSetCachingStrategyDontCache,
    /**
    Cache automatically. Data will be kept or removed according to internal behaviors.
    */
    MPDataSetCachingStrategyAutomatic,
    /**
    Cache manually. Data will be kept until data set is removed manually in the data set manager.
    */
    MPDataSetCachingStrategyManual,
};

#endif /* MPDataSetScope_h */
