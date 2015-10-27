//
//  MPAppData.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 8/16/13.
//  Copyright (c) 2013 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"
#import "MPSite.h"
#import "MPLocationDisplayRuleset.h"
#import "MPLatLngBounds.h"

@protocol MPTokenSet
@end

/** 
 * Provides the contextual information needed for setting up a map with specific MapsPeople site data
 */
@interface MPAppData : JSONModel
/**
 The app mode to run the map in
 @see MPAppMode
 */
@property int appMode;
/**
 * The site/app that the app data belongs to
 */
@property MPSite* site;
/**
 * Ruleset that defines how and when to show the different map markers
 */
@property MPLocationDisplayRuleset* displayRuleset;
/**	
 * Array of MapsPeople tile services (unique string names) that is used by the app
 */
@property NSArray* tileServices;
/**
 * Array of MapsPeople tile databases (unique string names) that is used by the app
 */
@property NSArray* tileDatabases;
/**
 * Map viewport bounds for the app
 */
@property MPLatLngBounds* bbox;
/**
 * Max map zoom level for the app
 */
@property double maxZoomLevel;

@property NSArray<MPTokenSet>* tokens;

@end
