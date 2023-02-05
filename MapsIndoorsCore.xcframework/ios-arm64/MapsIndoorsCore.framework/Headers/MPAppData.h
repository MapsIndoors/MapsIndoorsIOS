//
//  MPAppData.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 8/16/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/** 
   Provides the contextual information needed for setting up a map with specific MapsPeople site data
 */
@interface MPAppData : JSONModel
/**
 Ruleset that defines how and when to show the different map markers
 */
@property (strong, nonatomic, nullable, readonly) NSString* colorPrimary;
@property (strong, nonatomic, nullable, readonly) NSString* colorPrimaryDark;
@property (strong, nonatomic, nullable, readonly) NSString* colorAccent;
@property (strong, nonatomic, nullable, readonly) NSDictionary<NSString*, NSArray<NSDictionary*>*>* menuInfo;
@property (strong, nonatomic, nullable, readonly) NSDictionary<NSString*, NSString*>* venueImages;
@property (strong, nonatomic, nullable, readonly) NSDictionary<NSString*, NSString*>* appSettings;

@end
