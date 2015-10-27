//
//  LocalTileLayer.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 8/14/13.
//  Copyright (c) 2013 MapsPeople A/S. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>
#import "MPTileDB.h"

/**
 * Delegate protocol specification that specify an event method that fires when offline tile database is ready.
 */
@protocol MPOfflineTileLayerDelegate <NSObject>

/**
 * Event method that fires when offline tile database is ready.
 * @param layerType The layer type / identifier.
 */
@required
- (void) onOfflineTilesReady: (NSString*)layerIdentifier andLayer:(GMSTileLayer*)layer;
@end

/**
 * Offline tile layer class. Used to serve a Google map with downloadable MapsPeople tile databases.
 */
@interface MPOfflineTileLayer : GMSSyncTileLayer<MPDBDelegate>

/**
 * Layer type / identifier.
 */
@property NSString* layerType;
/**
 * The database storing tiles for this layer.
 */
@property MPTileDB* database;
/**
 * Delegate that holds an event method that fires when offline tile database is ready.
 */
@property (weak) id <MPOfflineTileLayerDelegate> delegate;

/**
 * Fire up the database.
 * @param layerType The layer type / identifier.
 */
- (void)loadTilesFromDB:(NSString*)layerType;
@end
