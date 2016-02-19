//
//  MPMapControl.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 9/17/13.
//  Copyright (c) 2013 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifdef USE_M4B
#import <GoogleMapsM4B/GoogleMaps.h>
#else
#import <GoogleMaps/GoogleMaps.h>
#endif
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


//! Project version number for MapsIndoorsSDK.
FOUNDATION_EXPORT double MapsIndoorsSDKVNum;

//! Project version string for MapsIndoorsSDK.
FOUNDATION_EXPORT const unsigned char MapsIndoorsSDKVStr[];

//@protocol MPLocatorDelegate <NSObject>
//@required
//- (void) MPLocator: onRouteChange;
//@end

/**
 * Empty protocol specification.
 */
@protocol MPOnlineTileLayer
@end
/**
 * Delegate protocol specification to hold the floor change event.
 */
@protocol MPMapControlDelegate <NSObject>
/**
 * Data fetch event method. Can be implemented by delegate object.
 */
@optional
- (void) appDataReady:(MPAppData*)appData;
/**
 * Data fetch event method. Can be implemented by delegate object.
 */

@optional
- (void) locationDataReady:(MPLocationDataset*)locations;
/**
 * Data fetch event method. Can be implemented by delegate object.
 */

@optional
- (void) solutionDataReady:(MPSolution*)solution;
/**
 * Data fetch event method. Can be implemented by delegate object.
 */

@optional
- (void) venueDataReady:(MPVenueCollection*)venueCollection;
/**
 * Data fetch event method. Can be implemented by delegate object.
 */

@optional
- (void) onPositionUpdate:(MPPositionResult*)positionResult;
/**
 * Location info snippet tap event method. Can be implemented by delegate object.
 */

@optional
- (void) infoSnippetTapped:(MPLocation*)location tapPosition:(NSString*)position;
/**
 * Location info snippet tap event method. Can be implemented by delegate object.
 */

@optional
- (void) floorDidChange:(NSNumber*)floor;

@end

/**
 Convenience class for setting up a Google map with MapsPeople venues, buildings, locations and other map content. To get started, setup a Google map and do:
 
 <code><pre>
 NSString* clientId = @"mapspeople-client-id";
 NSString* siteId = @"mapspeople-site-id";
 MPMapControl* mapControl = [[MPMapControl alloc] initWithMap: myGoogleMap];
 [mapControl setupMapWith: clientId site: siteId];
 </pre></code>
 
 To setup with locations, venues or routing from your own service, make a subclass of e.g. MPLocationsProvider, and do:
 
 <code><pre>
 MyCustomLocationsProvider* myProvider = [[MyCustomLocationsProvider alloc] init];
 MPRoutingProvider* myProvider = [[MPRoutingProvider alloc] init];
 NSString* clientId = @"mapspeople-client-id";
 NSString* siteId = @"mapspeople-site-id";
 MPMapControl* mapControl = [[MPMapControl alloc] initWithMap: myGoogleMap];
 [mapControl setupMapWith: clientId site: siteId locations: myProvider venues: nil routing: nil appData: nil];
 </pre></code>
 */
@interface MPMapControl : NSObject<GMSMapViewDelegate, MPFloorSelectorDelegate, MPBuildingDelegate, MPInfoSnippetViewDelegate, MPRouteActionDelegate, MPLocationsProviderDelegate, MPVenueProviderDelegate, MPRoutingProviderDelegate, MPPositionProviderDelegate, MPSolutionProviderDelegate>

/**
 * Delegate object containing data events
 */
@property (nonatomic, weak) id<MPMapControlDelegate> delegate;
/**
 * Provides the contextual information needed for setting up a map with specific MapsPeople site data
 */
@property MPAppData *appData;
/**
 * Floor selector UI element.
 */
@property MPFloorSelectorControl *floorSelector;
/**
 * Hide floor selector UI element.
 */
@property (nonatomic) BOOL floorSelectorHidden;
/**
 * Location info-snippet UI element.
 */
@property MPInfoSnippetView *infoSnippet;
/**
 * Routing UI element.
 */
@property MPRoutingControl *routingControl;
/**
 * Online tile layers.
 */
@property NSMutableDictionary *layers;
/**
 * Offline tile layers.
 */
@property NSMutableDictionary *offlineLayers;
/**
 * Latest routing query result.
 */
@property MPRoute* currentRoute;
/**
 * Load indicator that will show up on the map when setting up offline maps.
 */
@property MPLoadIndicator* loader;
/**
 * The buildings that belong to this map control.
 */
@property MPBuildingDataset* buildings;
/**
 * The solution that belong to this map control.
 */
@property (nonatomic) MPSolution* solution;
/**
 * The venues that belong to this map control.
 */
@property (nonatomic) MPVenueCollection* venueCollection;
/**
 * The current building in focus.
 */
@property MPBuilding* currentBuilding;
/**
 * The dataset containing current locations.
 */
@property (nonatomic)MPLocationDataset* locationData;
/**
 * The Google map reference.
 */
@property (nonatomic, strong) GMSMapView* map;
/**
 * The site id, used for fetching location data.
 */
@property NSString* siteId;
/**
 * The client id, used for fetching venue data.
 */
@property NSString* clientId;
/**
 * A reference to the google map delegate.
 */
@property (weak) id<GMSMapViewDelegate> GMSMapViewDelegate;
/**
 * The current floor.
 */
@property (nonatomic) NSNumber* currentFloor;
/**
 * The offline flag (default is false/online).
 */
@property BOOL offline;
/**
 * Whether or not to hide all map locations. Default is NO
 */
@property (nonatomic) BOOL mapLocationsHidden;
/**
 * The current camera position.
 */
@property GMSCameraPosition* currentCameraPosition;
/**
 * Locations provider.
 */
@property id<MPLocationsProvider> locationsProvider;
/**
 * Routing provider.
 */
@property MPRoutingProvider* routingProvider;
/**
 * Solution provider.
 */
@property MPSolutionProvider* solutionProvider;
/**
 * Venue provider.
 */
@property MPVenueProvider* venueProvider;
/**
 * Position provider.
 */
@property NSArray* positionProviders;
/**
 * Current user location.
 */
@property (nonatomic)MPPositionIndicator* currentPosition;
/**
 * Current route origin location.
 */
@property MPLocation* currentRouteOrigin;
/**
 * Current route destination location.
 */
@property MPLocation* currentRouteDestination;
/**
 * Current single location selection.
 */
@property (nonatomic) MPLocation* selectedLocation;
/**
 * Current location search result.
 */
@property (nonatomic) NSArray* searchResult;
/**
 * Current language.
 */
@property (nonatomic) NSString* language;
/**
 * Building locations.
 */
@property NSArray* buildingLocations;
@property UIButton* watermarkBtn;
/**
 * Watermark feature enabled
 */
@property Boolean isWatermarkEnabled;
/**
 * Initialize a MPMapControl object with given map.
 * @param map The map to build the map control on.
 */
- (id)initWithMap:(GMSMapView*) map;
/**
 * Setup the venue map with given providers.
 * @param locationsProvider The locations provider from which the MapControl is fetching its location data.
 * @param venueProvider The venue provider from which the MapControl is fetching its venue data.
 * @param routingProvider The routing provider to which the MapControl is performing its route requests.
 * @param appDataProvider The app data provider from which the MapControl is fetching app data, such as location display rules and location labelling.
 */
- (void)setupMapWith:(MPLocationsProvider*)locationsProvider
              venues:(MPVenueProvider*)venueProvider
             routing:(MPRoutingProvider*)routingProvider;
/**
 * Setup the venue map with default providers based on given client id (only venues).
 * @param clientId The MapsPeople client id.
 */
- (void)setupMapWith:(NSString*)clientId;
/**
 * Setup the venue map with default providers based on given client id and siteId (venues, locations and routing if accessible).
 * @param clientId The MapsPeople client id.
 * @param siteId The MapsPeople site id, used for locations and routing.
 */
- (void)setupMapWith:(NSString*)clientId site:(NSString*)siteId;
/**
 * Setup the venue map with default providers based on given client id and siteId (venues, locations and routing if accessible).
 * @param clientId The MapsPeople client id.
 * @param siteId The MapsPeople site id, used for locations and routing.
 * @param locationsProvider The locations provider from which the MapControl is fetching its location data.
 * @param venueProvider The venue provider from which the MapControl is fetching its venue data.
 * @param routingProvider The routing provider to which the MapControl is performing its route requests.
 * @param appDataProvider The app data provider from which the MapControl is fetching app data, such as location display rules and location labelling.
 */
- (void)setupMapWith:(NSString*)clientId
                site:(NSString*)siteId
           locations:(MPLocationsProvider*)locationsProvider
              venues:(MPVenueProvider*)venueProvider
             routing:(MPRoutingProvider*)routingProvider;

/**
 * Get the location that wraps the given marker.
 */
- (MPLocation*)getLocation:(GMSMarker*) marker;
/**
 * Get location by string id reference.
 */
- (MPLocation*)getLocationById:(NSString*) idString;
/**
 * Execute routing from one given to another given location
 */
- (void)routingFrom:(MPLocation *)from to:(MPLocation *)to by:(NSString*)travelMode avoid:(NSArray*)restrictions depart:(NSDate*)departureTime arrive:(NSDate*)arrivalTime;
/**
 * Venue collection setter. This will draw the venue on the map, if valid floor tileurl(s) exist.
 */
- (void)setVenueCollection:(MPVenueCollection *)venueCollection;
/**
 * Show a given array of locations. The display will override any zoom level condition made from display rules. Clear the locations by calling again with 
 * [showLocations:nil fitBounds:NO]
 */
- (void)showSearchResult:(BOOL)fitBounds;
/**
 * Add a location display rule - you need to know the categories applied to the map locations
 * The display rule name corresponds to the location category we want the rule to apply for
 * Adding a rule with name nil, will apply generally to all categories
 * Adding a rule with a name, will override a more general rule
 */
- (void)addDisplayRule:(MPLocationDisplayRule*)rule;
- (void)addDisplayRules:(NSArray<MPLocationDisplayRule>*)rules;
- (void)addPositionProvider:(id<MPPositionProvider>)provider;
- (void)clearUnusedTileCache;
- (void)clearMap;
- (void)showUserPosition:(BOOL)show;
- (void)showInfoSnippetWithLocation:(MPLocation*)location;
+ (NSString*) solutionId;
//TEMP
-(void) saveDataFor:(NSString*)key value:(NSString*)value;
- (NSString*) getDataFor:(NSString*)key;
- (void)goTo:(MPLocation*)location;
- (void)updateViews:(NSNotification *)notification;
+ (MPSolution*)getSolution;
@end
