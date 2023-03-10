//
//  MPMapControl+Private.h
//  MapsIndoors
//
//  Created by Christian Wolf Johannsen on 07/12/2022.
//  Copyright © 2022 MapsPeople A/S. All rights reserved.
//

#ifndef MPMapControl_Private_h
#define MPMapControl_Private_h

#import "MPMapControl.h"

@class MPLocationMarkerManager;
@protocol MPLocationsProvider;

NS_ASSUME_NONNULL_BEGIN

@interface MPMapControl ()

@property (nonatomic, strong) NSArray<GMSMarker*>* venueMarkers;

@property (nonatomic, strong) NSMutableDictionary* floorTileLayers;
/**
 A reference to the google map delegate.
 */
@property (weak) id<GMSMapViewDelegate> GMSMapViewDelegate;
/**
 Locations provider.
 */
@property id<MPLocationsProvider> locationsProvider;
/**
 The Google map reference.
 */
@property (nonatomic, strong) GMSMapView* map;
@property (nonatomic, strong) MPLocationMarkerManager* markerMngr;
@property (nonatomic) BOOL userGestureInProgress;
/**
 The venues that belong to this map control.
 */
@property (nonatomic) MPVenueCollection* venueCollection;

- (void)redrawMarkerIcons;
- (void)reloadTilelayer;
- (void)showAreaOfCoordinateBounds:(GMSCoordinateBounds*)bounds centerCoordinate:(CLLocationCoordinate2D)centerCoordinate forceZoom:(BOOL)forceZoom;
- (void)updateSelectedLocationOnMap:(MPLocation* _Nullable)selectedLocation;
- (void)updateViewsForMap:(GMSMapView*)mapView isMapViewEvent:(BOOL)isMapViewEvent;

@end

NS_ASSUME_NONNULL_END

#endif /* MPMapControl_Private_h */
