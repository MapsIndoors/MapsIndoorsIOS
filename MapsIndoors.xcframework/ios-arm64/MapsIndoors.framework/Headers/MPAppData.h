//
//  MPAppData.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 8/16/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

@import JSONModel;
#import "MPMenuItem.h"


/** 
   Provides the contextual information needed for setting up a map with specific MapsPeople site data
 */
@interface MPAppData : JSONModel
/**
 Ruleset that defines how and when to show the different map markers
 */
@property (strong, nonatomic, nullable) NSString<Optional>* colorPrimary;
@property (strong, nonatomic, nullable) NSString<Optional>* colorPrimaryDark;
@property (strong, nonatomic, nullable) NSString<Optional>* colorAccent;
@property (strong, nonatomic, nullable) NSDictionary<NSString*, NSArray<NSDictionary*>*>* menuInfo;
@property (strong, nonatomic, nullable) NSDictionary<NSString*, NSString*><Optional>* venueImages;
@property (strong, nonatomic, nullable) NSDictionary<NSString*, NSString*><Optional>* appSettings;

@end
