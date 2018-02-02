//
//  MPMapControl.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 9/17/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "MPLocation.h"
#import "MPAppData.h"
#import "MPLocationDataset.h"
#import "MPFloorSelectorControl.h"
#import "MPCategoryUIBarButtonItem.h"
#import "MPLoadIndicator.h"
#import "MPOnlineTileLayer.h"
#import "MPBuildingDataset.h"
#import "MPLocationDataset.h"
#import "MPRoutingControl.h"
#import "MPLayerType.h"
#import "MPInfoSnippetView.h"
#import "MPRoutingProvider.h"
#import "MPLocationsProvider.h"
#import "MPVenueProvider.h"
#import "MPSolutionProvider.h"
#import "MPLocationDisplayRule.h"
#import "MPPositionProvider.h"
#import "MPPositionIndicator.h"


//! Project version number for MapsIndoors.
FOUNDATION_EXPORT double MapsIndoorsVNum;

//! Project version string for MapsIndoors.
FOUNDATION_EXPORT const unsigned char MapsIndoorsVStr[];

//@protocol MPLocatorDelegate <NSObject>
//@required
//- (void) MPLocator: onRouteChange;
//@end

/**
  Empty protocol specification.
 */
@protocol MPOnlineTileLayer
@end
/**
  Delegate protocol specification to hold the floor change event.
 */
@protocol MPMapControlDelegate <NSObject>
/**
 Data ready event method. Can be implemented by delegate object.
 */
@optional
- (void) mapContentReady;

/**
  Data fetch event method. Can be implemented by delegate object.
 */
@optional
- (void) appDataReady:(MPAppData*)appData DEPRECATED_MSG_ATTRIBUTE("Use mapContentReady instead");

/**
  Data fetch event method. Can be implemented by delegate object.
 */
@optional
- (void) locationDataReady:(MPLocationDataset*)locations DEPRECATED_MSG_ATTRIBUTE("Use mapContentReady instead");

/**
  Data fetch event method. Can be implemented by delegate object.
 */
@optional
- (void) solutionDataReady:(MPSolution*)solution DEPRECATED_MSG_ATTRIBUTE("Use mapContentReady instead");

/**
  Data fetch event method. Can be implemented by delegate object.
 */
@optional
- (void) venueDataReady:(MPVenueCollection*)venueCollection DEPRECATED_MSG_ATTRIBUTE("Use mapContentReady instead");

/**
  Data fetch event method. Can be implemented by delegate object.
 */
@optional
- (void) onPositionUpdate:(MPPositionResult*)positionResult DEPRECATED_MSG_ATTRIBUTE("Use MPPositionProvider instead");

/**
  Location info snippet tap event method. Can be implemented by delegate object.
 */
@optional
- (void) infoSnippetTapped:(MPLocation*)location tapPosition:(NSString*)position DEPRECATED_ATTRIBUTE;

/**
  Location info snippet tap event method. Can be implemented by delegate object.
 */
@optional
- (void) floorDidChange:(NSNumber*)floor;

/**
 Called when MPMapControl wants to automatically switch floor, for example when the map is panned and the visible buildings have changed.
 
 @param toFloor The floor being changed to.
 @return YES if the floor change is allowed, else NO.
 */
@optional
- (BOOL) allowAutomaticSwitchToFloor:(NSNumber*)toFloor;

@end

/**
 Convenience class for setting up a Google map with MapsIndoors venues, buildings, locations and other map content.
 */
@interface MPMapControl : NSObject<GMSMapViewDelegate, MPFloorSelectorDelegate, MPBuildingDelegate, MPLocationsProviderDelegate, MPVenueProviderDelegate, MPPositionProviderDelegate>

/**
  Delegate object containing data events
 */
@property (nonatomic, weak) id<MPMapControlDelegate> delegate;

/**
  Custom floor selector for the map to use.
  When provided, the MapControl will not create a floor selector control autonomously.
 */
@property (nonatomic, strong) id<MPFloorSelectorProtocol>       customFloorSelector;

/**
  Floor selector UI element.
 
  If a custom floor selector is not provided (@sa customFloorSelector), MPMapControl will create a default floor selector.
  If you need a customized floor selector beyond what MPFloorSelectorControl provides, 
  or need finer control over location and visibility of the floor selector, 
  a custom floor selector can be provided to the MapControl using the MPFloorSelectorControl property.
 
  May be nil if a custom floor selector has been provided.
 */
@property (readonly) MPFloorSelectorControl* floorSelector;

/**
  Hide floor selector UI element.
  Only applies to default floor selector; if a custom floor selector is provided, the MapControl is not repsonsible for it's visibility.
 */
@property (nonatomic) BOOL floorSelectorHidden;

/**
 Current user location.
 */
@property (nonatomic)MPPositionIndicator* currentPosition;
/**
 Current single location selection.
 */
@property (nonatomic) MPLocation* selectedLocation;
/**
 Current location search result.
 */
@property (nonatomic) NSArray* searchResult;
/**
 Current language.
 */
@property (nonatomic) NSString* language DEPRECATED_MSG_ATTRIBUTE("Use [MapsIndoors getLanguage]/[MapsIndoors setLanguage:] instead");
/**
 The current floor.
 */
@property (nonatomic) NSNumber* currentFloor;
/**
 Whether or not to hide all map locations. Default is NO
 */
@property (nonatomic) BOOL mapLocationsHidden;
/**
 The venue name, at which the map should target its view.
 */
@property (nonatomic) NSString* venue;

/**
  Initialize a MPMapControl object with given map.
  @param map The map to build the map control on.
 */
- (id)initWithMap:(GMSMapView*) map;
/**
  Setup the venue map with given providers.
  @param locationsProvider The locations provider from which the MapControl is fetching its location data.
  @param venueProvider The venue provider from which the MapControl is fetching its venue data.
  @param routingProvider The routing provider to which the MapControl is performing its route requests.
  @param appDataProvider The app data provider from which the MapControl is fetching app data, such as location display rules and location labelling.
 */
- (void)setupMapWith:(MPLocationsProvider*)locationsProvider
              venues:(MPVenueProvider*)venueProvider
             routing:(MPRoutingProvider*)routingProvider DEPRECATED_MSG_ATTRIBUTE("Use [MapsIndoors provideApiKey:contentKey:] and initWithMap: when setting up");
/**
  Setup the venue map with default providers based on given solution id (only venues).
  @param solutionId The MapsPeople solution id.
 */
- (void)setupMapWith:(NSString*)solutionId DEPRECATED_MSG_ATTRIBUTE("Use [MapsIndoors provideApiKey:contentKey:] and initWithMap: when setting up");
/**
  Setup the venue map with default providers based on given solution id (venues, locations and routing if accessible).
  @param solutionId The MapsPeople solution id.
  @param venueName The MapsPeople site id, used for locations and routing.
 */
- (void)setupMapWith:(NSString*)solutionId site:(NSString*)venueName DEPRECATED_MSG_ATTRIBUTE("Use only [MapsIndoors provideApiKey:contentKey:] and initWithMap: when setting up");
/**
  Setup the venue map with default providers based on given solution id (venues, locations and routing if accessible).
  @param solutionId The MapsPeople solution id.
  @param venueName The MapsPeople site id, used for locations and routing.
  @param locationsProvider The locations provider from which the MapControl is fetching its location data.
  @param venueProvider The venue provider from which the MapControl is fetching its venue data.
  @param routingProvider The routing provider to which the MapControl is performing its route requests.
  @param appDataProvider The app data provider from which the MapControl is fetching app data, such as location display rules and location labelling.
 */
- (void)setupMapWith:(NSString*)solutionId
                site:(NSString*)venueName
           locations:(MPLocationsProvider*)locationsProvider
              venues:(MPVenueProvider*)venueProvider
             routing:(MPRoutingProvider*)routingProvider DEPRECATED_MSG_ATTRIBUTE("Use only [MapsIndoors provideApiKey:contentKey:] and initWithMap: when setting up");

/**
  Get the location that wraps the given marker.
 */
- (MPLocation*)getLocation:(GMSMarker*) marker;
/**
  Get location by string id reference.
 */
- (MPLocation*)getLocationById:(NSString*) idString;
/**
  Show a given array of locations. The display will override any zoom level condition made from display rules. Clear the locations by calling again with 
  [showLocations:nil fitBounds:NO]
 */
- (void)showSearchResult:(BOOL)fitBounds;
/**
  Add a location display rule - you need to know the categories applied to the map locations
  The display rule name corresponds to the location category we want the rule to apply for
  Adding a rule with name nil, will apply generally to all categories
  Adding a rule with a name, will override a more general rule
 */
- (void)addDisplayRule:(MPLocationDisplayRule*)rule;
- (void)addDisplayRules:(NSArray<MPLocationDisplayRule>*)rules;
- (void)addPositionProvider:(id<MPPositionProvider>)provider;
- (void)clearTileCache;
- (void)clearMap;
- (void)showUserPosition:(BOOL)show;
- (void)goTo:(MPLocation*)location;
- (void)updateViews:(NSNotification *)notification;
@end
