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
#import "MPLoadIndicator.h"
#import "MPOnlineTileLayer.h"
#import "MPBuildingDataset.h"
#import "MPLocationDataset.h"
#import "MPLayerType.h"
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


#pragma mark - MPMapControlDelegate


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
  Show flooar changed event method. Can be implemented by delegate object.
 */
@optional
- (void) floorDidChange:(nonnull NSNumber*)floor;

/**
 Focused building changed event method.
 @param building The focused building on the map, may be nil.
 */
@optional
- (void) focusedBuildingDidChange:(nullable MPLocation*)building;

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

/**
 Callback for the app to know and determine what should happen when a POI group/cluster marker is tapped.

 @param marker The marker that was tapped
 @param locations The MPlocations that was grouped.
 @param moreZoomPossible YES if the map is able to zoom more in, else NO.
 @return YES to enable the default behaviour, which is to zoom to the area of the POI group if possible, else show an info window for the POI group.
 @return NO if no further handling of the maker-tap should occur.
 */
@optional
- (BOOL) didTapMarker:(GMSMarker*_Nonnull)marker forLocationCluster:(nullable NSArray<MPLocation*>*)locations moreZoomPossible:(BOOL)moreZoomPossible;

/**
 Called to get an infoWindow for a map-marker representing a poi-group.

 @param locationCluster The MPLocations in the group.
 @return nil to use default info window.
 @return UIView* to use a specific, application-created, infoWindow.
 */
@optional
- (nullable UIView*) infoWindowForLocationCluster:(NSArray<MPLocation*>* _Nonnull)locationCluster;

/**
 Callback for the application to determine the size of the grouping/clustering image representing a poi group.

 @param count The number of POIs grouped into a cluster.
 @param clusterId The clusterId that size is requested for.
 @return size.
 */
@optional
- (CGSize) getImageSizeForLocationClusterWithCount:(NSUInteger)count clusterId:(NSString* _Nonnull)clusterId;

/**
 Callback for synchronously providing an image for a POI group (aka POI cluster).
 If both the async and sync variants of this method is implemented, the asynchronous variant is used.

 @param locationCluster List of grouped POIs
 @param imageSize The image size to return.
 @param clusterId clusterId of the poi group.
 @return YES if the image request is accepted, essentially promising to call the completion block at some point in the future.
 @return NO if the image request will not be fulfilled by the completion handler. Returning NO make the map show the default grouping image.
 */
@optional
- (nullable UIImage*) getImageForLocationCluster:(NSArray<MPLocation*>* _Nonnull)locationCluster imageSize:(CGSize)imageSize clusterId:(NSString* _Nonnull)clusterId;

/**
 Callback for asynchronously providing an image for a POI group (aka POI cluster).

 @param locationCluster List of grouped POIs
 @param imageSize The image size to return.
 @param clusterId clusterId of the poi group.
 @param completion completion handler to deliver the image.
 @return YES if the image request is accepted, essentially promising to call the completion block at some point in the future.
 @return NO if the image request will not be fulfilled by the completion handler. Returning NO make the map show the default grouping image.
 */
@optional
- (BOOL) getImageForLocationCluster:(NSArray<MPLocation*>* _Nonnull)locationCluster imageSize:(CGSize)imageSize clusterId:(NSString* _Nonnull)clusterId completion:(void(^_Nonnull)(UIImage* _Nullable image))completion;

/**
 Called when MPMapControl receives a new position update.

 @param positionResult The position result as estimated or calculated by a @sa MPPositionProvider
 */
@optional
- (void) onPositionUpdate:(nonnull MPPositionResult*)positionResult;

/**
 Called when MPMapControl receives a location update.

 @param location The location that was updated
 */
@optional
- (void) willUpdateLocationsOnMap:(nonnull NSArray<MPLocation*>*)locations NS_SWIFT_NAME(willUpdateLocationsOnMap(locations:));;

@end


#pragma mark - MPMapControl


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
 @deprecated Use MapsIndoors.positionProvider.latestPositionResult if you need to know the current position.
 */
@property (nonatomic, nullable, readonly) MPPositionIndicator* currentPosition  DEPRECATED_ATTRIBUTE;
/**
 Current single location selection.
 */
@property (nonatomic, nullable) MPLocation* selectedLocation;
/**
 Current location search result.
 */
@property (nonatomic, nullable) NSArray<MPLocation*>* searchResult;
/**
 The current floor.
 */
@property (nonatomic, nullable) NSNumber* currentFloor;
/**
 The map style.
 */
@property (nonatomic, nullable) MPMapStyle* mapStyle;
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


#pragma mark - Display rule support

/**
  Add a location display rule for a specific location type.
  You need to know the types applied to the map locations.
  The display rule name corresponds to the location type we want the rule to apply for.
  Adding a rule with name nil, will apply generally to all types
  Adding a rule with a name, will override a more general rule
  @param rule displayrule to add.
  @since 3.7.0
 */
- (void) setDisplayRule:(nonnull MPLocationDisplayRule*)rule;

/**
 Add multiple location display rules.
 @sa setDisplayRule

 @param rules Array of displayrules to add.
 @since 3.7.0
 */
- (void) setDisplayRules:(nonnull NSArray<MPLocationDisplayRule*>*)rules;

/**
 Add a location display rule for a single MPLocation.
 This display rule takes precedence over more general displayrules like the type-display-rule and default display rule.
 @param rule Display rule to use for the given MPLocation.
 @param location MPLocation that the displayrule should apply to.
 @since 3.7.0
 */
- (void) setDisplayRule:(nonnull MPLocationDisplayRule*)rule forLocation:(nonnull MPLocation*)location;

/**
 Add a location display rule for multiple MPLocations.
 This display rule takes precedence over more general displayrules like the type-display-rule and default display rule.
 @param rule Display rule to use for the given MPlocations.
 @param locations MPLocation's that the displayrule should apply to.
 @since 3.7.0
 */
- (void) setDisplayRule:(nonnull MPLocationDisplayRule*)rule forLocations:(nonnull NSArray<MPLocation*>*)locations;

/**
 Apply a named displayRule to the given MPLocation.
 If MPMapControl does not have a displayRule with the given name, no changes is applied.
 @param ruleName Name of displayRule to apply to location
 @param location MPLocation to apply displayRule to
 @since 3.7.0
 */
- (void) setDisplayRuleNamed:(nonnull NSString*)ruleName forLocation:(nonnull MPLocation*)location;

/**
 Get a type-displayRule by name.
 @param ruleName Name of type-displayRule to retrieve.
 @return nil or MPLocationDisplayRule
 @since 3.7.0
 */
- (MPLocationDisplayRule* _Nullable) getDisplayRuleForTypeNamed:(nonnull NSString*)ruleName;

/**
 Get the currently used displayRule for the given MPLocation.
 Note that the returned displayRule may be, in priority-order, one of:
    - a custom, override displayRule registered with this instance of MPMapControl
    - a custom displayRule assigned to the MPLocation object
    - a shared displayRule for the 'MPLocation type'
    - the shared , default display rule
 @param location The MPLocation to retrieve the currently active displayRule for.
 @return MPLocationDisplayRule*
 @since 3.7.0
 */
- (MPLocationDisplayRule* _Nullable) getEffectiveDisplayRuleForLocation:(nonnull MPLocation*)location;

/**
 Remove any specific displayrule that has been added to the given MPLocation.
 Once the location-specific display rule is removed, the MPLocation will be displayed on map according to it's type-displayrule.
 @param location MPLocation that should have it's specific displayrule removed.
 @since 3.7.0
 */
- (void) resetDisplayRuleForLocation:(nonnull MPLocation*)location;

/**
Remove any specific displayrule that has been added to the given MPLocations.
Once the location-specific display rules are removed, the MPLocations will be displayed on map according to their type-displayrule.
@param locations MPLocations that should have their specific displayrule removed.
@since 3.7.0
*/
- (void) resetDisplayRulesForLocations:(nonnull NSArray<MPLocation*>*)locations;

/**
 The display rule used by MPMapControl to highlight the selected location.
 Created and added by MPMapControl during initialization.
 Modify this displayrule to change the visual appearance of the location highlight.
 */
@property (nonatomic, strong, readonly) MPLocationDisplayRule* _Nullable      locationHighlightDisplayRule;

/**
 The default display settings used by MPMapControl to display a location.
 Modify this object to change the default visual appearance of a location.
 The default appearance only applies for locations that has no other references to a display rule.
 */
@property (nonatomic, strong, readonly) MPLocationDisplayRule* _Nullable      defaultDisplayRule;


#pragma mark - Configuration
/**
 The font that MapsIndoors should use when rendering labels on the map.
 */
@property (class, nullable) UIFont* mapLabelFont;

/**
 The color that MapsIndoors should use when rendering labels on the map.
 */
@property (class, nullable) UIColor* mapLabelColor;

/**
 Default map icon size
 */
@property(class) CGSize mapIconSize;

/**
 Returns whether halo is enabled for map labels.
 */
+ (BOOL)isMapLabelHaloEnabled;

/**
 Set the font that MapsIndoors should use when rendering labels on the map, and enable or disable white halo for improved visibility.
 */
+ (void)setMapLabelFont:(UIFont * _Nullable)mapLabelFont showHalo: (BOOL) showHalo;

/**
 Controls whether overlapping map markers can be resolved by grouping some of the overlapping items.
 Default value is NO;
 When set to YES, the default behavior is to group MPLocation's of the same type.
 */
@property(class) BOOL   locationClusteringEnabled;

/**
 Controls whether overlapping map markers can be resolved by hiding some of the overlapping items.
 Default value is YES;
 */
@property(class) BOOL   locationHideOnIconOverlapEnabled;

/**
 Overall range reserved for MapsIndoors use.
 */
@property (readonly) NSRange        zIndexRangeForMapsIndoorsOverlays;

/**
 zIndex range reserved for polygon overlays managed by the MapsIndoors.
 */
@property (readonly) NSRange        zIndexRangeForPolygonOverlays;

/**
 zIndex of the user location marker (aka "the blue dot").
 */
@property (readonly) int zIndexForUserLocationMarker;

/**
 zIndex of the accurqacy indicator circle.
 */
@property (readonly) int zIndexForPositioningAccuracyCircle;

/**
 zIndex for building outline highlight overlay
 */
@property (readonly) int zIndexForBuildingOutlineHighlight;

/**
zIndex for location outline highlight overlay
*/
@property (readonly) int zIndexForLocationOutlineHighlight;

/**
 Indexes reserved for MapsIndoors tile layers.
 If you are adding tilelayers to a map with MapsIndoors tiles, you should set the zIndex of your tile layer above this range to make sure your tile layer shows on top of MapsIndoors tiles.
 */
@property (readonly) NSRange        zIndexRangeForMapsIndoorsTileLayers;


#pragma mark -

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


#pragma mark - Accessibility support

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



#pragma mark - Deprecations
/**
 @sa setDisplayRule
 @deprecated Replaced by -[setDisplayRule:] in version 3.7.0
 */
- (void) addDisplayRule:(nonnull MPLocationDisplayRule*)rule DEPRECATED_ATTRIBUTE;

/**
 @sa setDisplayRules
 @deprecated Replaced by -[setDisplayRules:] in version 3.7.0
 */
- (void) addDisplayRules:(nonnull NSArray<MPLocationDisplayRule*>*)rules DEPRECATED_ATTRIBUTE;

@end
