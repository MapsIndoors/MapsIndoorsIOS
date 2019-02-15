//
//  MPMapControl.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 9/17/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "MPDefines.h"
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
 @deprecated
 */
@optional
- (void) appDataReady:(nonnull MPAppData*)appData MP_DEPRECATED_MSG_ATTRIBUTE("Use mapContentReady instead");

/**
  Data fetch event method. Can be implemented by delegate object.
 @deprecated
 */
@optional
- (void) locationDataReady:(nonnull MPLocationDataset*)locations MP_DEPRECATED_MSG_ATTRIBUTE("Use mapContentReady instead");

/**
  Data fetch event method. Can be implemented by delegate object.
 @deprecated
 */
@optional
- (void) solutionDataReady:(nonnull MPSolution*)solution MP_DEPRECATED_MSG_ATTRIBUTE("Use mapContentReady instead");

/**
  Data fetch event method. Can be implemented by delegate object.
 @deprecated
 */
@optional
- (void) venueDataReady:(nonnull MPVenueCollection*)venueCollection MP_DEPRECATED_MSG_ATTRIBUTE("Use mapContentReady instead");

/**
  Data fetch event method. Can be implemented by delegate object.
 @deprecated
 */
@optional
- (void) onPositionUpdate:(nonnull MPPositionResult*)positionResult MP_DEPRECATED_MSG_ATTRIBUTE("Use MPPositionProvider instead");

/**
  Location info snippet tap event method. Can be implemented by delegate object.
 */
@optional
- (void) infoSnippetTapped:(nonnull MPLocation*)location tapPosition:(nonnull NSString*)position MP_DEPRECATED_ATTRIBUTE;

/**
  Location info snippet tap event method. Can be implemented by delegate object.
 */
@optional
- (void) floorDidChange:(nonnull NSNumber*)floor;

/**
 Called when MPMapControl wants to automatically switch floor, for example when the map is panned and the visible buildings have changed.
 
 @param toFloor The floor being changed to.
 @return YES if the floor change is allowed, else NO.
 */
@optional
- (BOOL) allowAutomaticSwitchToFloor:(nonnull NSNumber*)toFloor;

/**
 Called when the user taps the map.
 
 If this delegate-method is *not* implemented, MPMapControl's default behaviour is used.
 If this method is implemented, returning YES will still invoke default baheviour.
 
 The default handling by MPMapControl is to select the first item in the locations-list, and add a highlight to the area of the location.

 @param coordinate Tap coordinate
 @param locations List of MPLocations at that point
 @return YES to invoke default behaviour, NO to disable default behaviour.
 */
@optional
- (BOOL) didTapAtCoordinate:(CLLocationCoordinate2D)coordinate withLocations:(nullable NSArray<MPLocation*>*)locations;

@end

/**
 Convenience class for setting up a Google map with MapsIndoors venues, buildings, locations and other map content.
 */
@interface MPMapControl : NSObject<GMSMapViewDelegate, MPFloorSelectorDelegate, MPBuildingDelegate, MPVenueProviderDelegate, MPPositionProviderDelegate>

/**
  Delegate object containing data events
 */
@property (nonatomic, weak, nullable) id<MPMapControlDelegate> delegate;

/**
  Custom floor selector for the map to use.
  When provided, the MapControl will not create a floor selector control autonomously.
 */
@property (nonatomic, strong, nullable) id<MPFloorSelectorProtocol>       customFloorSelector;

/**
  Floor selector UI element.
 
  If a custom floor selector is not provided (@sa customFloorSelector), MPMapControl will create a default floor selector.
  If you need a customized floor selector beyond what MPFloorSelectorControl provides, 
  or need finer control over location and visibility of the floor selector, 
  a custom floor selector can be provided to the MapControl using the MPFloorSelectorControl property.
 
  May be nil if a custom floor selector has been provided.
 */
@property (readonly, nullable) MPFloorSelectorControl* floorSelector;

/**
  Hide floor selector UI element.
  Only applies to default floor selector; if a custom floor selector is provided, the MapControl is not repsonsible for it's visibility.
 */
@property (nonatomic) BOOL floorSelectorHidden;

/**
 Current user location.
 */
@property (nonatomic, nullable) MPPositionIndicator* currentPosition;
/**
 Current single location selection.
 */
@property (nonatomic, nullable) MPLocation* selectedLocation;
/**
 Current location search result.
 */
@property (nonatomic, nullable) NSArray<MPLocation*>* searchResult;
/**
 Current language.
 @deprecated
 */
@property (nonatomic, nullable) NSString* language MP_DEPRECATED_MSG_ATTRIBUTE("Use [MapsIndoors getLanguage]/[MapsIndoors setLanguage:] instead");
/**
 The current floor.
 */
@property (nonatomic, nullable) NSNumber* currentFloor;
/**
 Whether or not to hide all map locations. Default is NO
 */
@property (nonatomic) BOOL mapLocationsHidden;
/**
 The venue name, at which the map should target its view.
 */
@property (nonatomic, nullable) NSString* venue;

/**
 Indicates whether or not basic data for the map has been loaded.
 This does *not* indicate whether maptiles have been loaded and displayed.
 */
@property (nonatomic, readonly) BOOL    mapContentReady;

/**
  Initialize a MPMapControl object with given map.
  @param map The map to build the map control on.
 */
- (nullable instancetype)initWithMap:(nonnull GMSMapView*) map;

/**
  Setup the venue map with given providers.
  @param locationsProvider The locations provider from which the MapControl is fetching its location data.
  @param venueProvider The venue provider from which the MapControl is fetching its venue data.
  @param routingProvider The routing provider to which the MapControl is performing its route requests.
 @deprecated
 */
- (void)setupMapWith:(nonnull MPLocationsProvider*)locationsProvider
              venues:(nonnull MPVenueProvider*)venueProvider
             routing:(nonnull MPRoutingProvider*)routingProvider MP_DEPRECATED_MSG_ATTRIBUTE("Use [MapsIndoors provideApiKey:contentKey:] and initWithMap: when setting up");

/**
  Setup the venue map with default providers based on given solution id (only venues).
  @param solutionId The MapsPeople solution id.
 @deprecated
 */
- (void)setupMapWith:(nonnull NSString*)solutionId MP_DEPRECATED_MSG_ATTRIBUTE("Use [MapsIndoors provideApiKey:contentKey:] and initWithMap: when setting up");

/**
  Setup the venue map with default providers based on given solution id (venues, locations and routing if accessible).
  @param solutionId The MapsPeople solution id.
  @param venueName The MapsPeople site id, used for locations and routing.
 @deprecated
 */
- (void)setupMapWith:(nonnull NSString*)solutionId site:(nullable NSString*)venueName MP_DEPRECATED_MSG_ATTRIBUTE("Use only [MapsIndoors provideApiKey:contentKey:] and initWithMap: when setting up");

/**
  Setup the venue map with default providers based on given solution id (venues, locations and routing if accessible).
  @param solutionId The MapsPeople solution id.
  @param venueName The MapsPeople site id, used for locations and routing.
  @param locationsProvider The locations provider from which the MapControl is fetching its location data.
  @param venueProvider The venue provider from which the MapControl is fetching its venue data.
  @param routingProvider The routing provider to which the MapControl is performing its route requests.
 @deprecated
 */
- (void)setupMapWith:(nonnull NSString*)solutionId
                site:(nonnull NSString*)venueName
           locations:(nonnull MPLocationsProvider*)locationsProvider
              venues:(nonnull MPVenueProvider*)venueProvider
             routing:(nonnull MPRoutingProvider*)routingProvider MP_DEPRECATED_MSG_ATTRIBUTE("Use only [MapsIndoors provideApiKey:contentKey:] and -[initWithMap:] or -[setupMapWithVenue:] when setting up");

/**
 Setup the venue map with default providers based on MapsIndoors.solutionId.
 @param venueName The MapsPeople site id, used for locations and routing.
 */
- (void) setupMapWithVenue:(nonnull NSString*)venueName;

/**
  Get the location that wraps the given marker.
 */
- (nullable MPLocation*)getLocation:(nonnull GMSMarker*) marker;

/**
  Get location by string id reference.
 */
- (nullable MPLocation*)getLocationById:(nonnull NSString*) idString;

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
- (void)addDisplayRule:(nonnull MPLocationDisplayRule*)rule;

/**
 Add multiple lcoation display rules.
 @sa addDisplayRule

 @param rules Array of displayrules to add.
 */
- (void)addDisplayRules:(nonnull NSArray<MPLocationDisplayRule*>*)rules;

/**
 The display rule used by MPMapControl to highlight the selected location.
 Created and added by MPMapControl during initialization.
 Modify this displayrule to change the visual appearance of the location highlight.
 */
@property (nonatomic, strong, readonly) MPLocationDisplayRule* _Nullable      locationHighlightDisplayRule;

/**
 Deprecated, Use MapsIndoors.positionProvider instead

 @param provider positioning provider to register with MPMapControl.
 @deprecated
 */
- (void)addPositionProvider:(nonnull id<MPPositionProvider>)provider MP_DEPRECATED_MSG_ATTRIBUTE("Use MapsIndoors.positionProvider instead");

- (void)clearTileCache;

/**
 Remove all markers associated with search results and selected location from the map.
 */
- (void)clearMap;

/**
 Show or hide the user position marker.

 @param show show/hide
 */
- (void)showUserPosition:(BOOL)show;

/**
 Focus the map on the given location.

 @param location The location to show on the map.
 */
- (void)goTo:(nonnull MPLocation*)location;

/**
 Make sure the complete geometry of the given MPLocation is visible on the map.
 If the location is fully visible, the visible area of the map is unchanged.
 If the location is not fully visible, the map is centered around the location, and if needed zoomed.
 This method does not change the shown floor.
 The maps current bearing and vieweing angle is preserved.

 @param location Location to show.
 */
- (void) showAreaOfLocation:(nonnull MPLocation*)location;

/**
 The accessibility label associated with the user location marker on the map.
 Default: "My Location"
 */
@property (nonatomic, strong, nullable) NSString*   userLocationAccessibilityLabel;

/**
 The accessibility label associated with the user location accuracy circle on the map.
 Default: "My location, accuracy %@m"
 */
@property (nonatomic, strong, nullable) NSString*   userLocationAccuracyAccessibilityLabel;


@end
