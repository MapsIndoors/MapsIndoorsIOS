//
//  MPAppData.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 8/16/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"
@import MapsIndoors;

@class MPLoggingConfig;

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/** 
   Provides the contextual information needed for setting up a map with specific MapsPeople site data
 */
@interface MPAppData : JSONModel <MPAppConfig>
/**
 Ruleset that defines how and when to show the different map markers
 */
@property (copy, nonatomic, nullable) NSString* colorPrimary;
@property (copy, nonatomic, nullable) NSString* colorPrimaryDark;
@property (copy, nonatomic, nullable) NSString* colorAccent;
@property (copy, nonatomic, nullable) NSDictionary<NSString*, NSArray<id<MPMenuInfo>>*>* menuInfo;
@property (copy, nonatomic, nullable) NSDictionary<NSString*, NSString*>* venueImages;
@property (copy, nonatomic, nullable) NSDictionary<NSString*, NSString*>* appSettings;

// Moved from MPAppData+Private
@property (nonatomic, strong, nullable) MPLoggingConfig* loggingConfig;

@end
