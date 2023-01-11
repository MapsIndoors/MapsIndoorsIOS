//
//  MPMapControl.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 9/17/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MPDefines.h"
#import "MPLocation.h"
#import "MPAppData.h"
#import "MPFloorSelectorControl.h"
#import "MPLayerType.h"
#import "MPRoutingProvider.h"
#import "MPVenueProvider.h"
#import "MPSolutionProvider.h"
#import "MPPositionProvider.h"
#import "MPFilterBehavior.h"
#import "MPSelectionBehavior.h"
#import "MPFilter.h"
#import "MPMapStyle.h"

@class MPDisplayRule;
@protocol MPMapConfig;

NS_ASSUME_NONNULL_BEGIN

//! Project version number for MapsIndoors.
FOUNDATION_EXPORT double MapsIndoorsVNum;

//! Project version string for MapsIndoors.
FOUNDATION_EXPORT const unsigned char MapsIndoorsVStr[];

#pragma mark - MPMapControlDelegate

/**
  Delegate protocol specification to hold the floor change event.
 */
@protocol MPMapControlDelegate <NSObject>
/**
 Data ready event method. Can be implemented by delegate object.
 */
@optional
- (void)mapContentReady;

/**
  Show floor changed event method. Can be implemented by delegate object.
 */
@optional
- (void)floorDidChange:(NSNumber*)floorIndex;

/**
 Focused building changed event method.
 @param building The focused building on the map, may be nil.
 */
@optional
- (void)focusedBuildingDidChange:(nullable MPLocation*)building;

/**
 Called when MPMapControl wants to automatically switch floor, for example when the map is panned and the visible buildings have changed.
 
 @param toFloorIndex The floor index being changed to.
 @return YES if the floor change is allowed, else NO.
 */
@optional
- (BOOL)allowAutomaticSwitchToFloor:(NSNumber*)toFloorIndex;

/**
 Called when the user taps the map.
 
 If this delegate method is *not* implemented, MPMapControl's default behaviour is used.
 If this method is implemented, returning YES will still invoke default baheviour.
 
 The default handling by MPMapControl is to select the first item in the locations list, and add a highlight to the area of the location.

 @param coordinate Tap coordinate
 @param locations List of MPLocations at that point
 @return YES to invoke default behaviour, NO to disable default behaviour.
 */
@optional
- (BOOL)didTapAtCoordinate:(CLLocationCoordinate2D)coordinate withLocations:(nullable NSArray<MPLocation*>*)locations;

/**
 Called to get an infoWindow for a map marker representing a POI group.

 @param locationCluster The MPLocations in the group.
 @return nil to use default info window.
 @return UIView* to use a specific, application-created, infoWindow.
 */
@optional
- (nullable UIView*)infoWindowForLocationCluster:(NSArray<MPLocation*>*)locationCluster;

/**
 Callback for the application to determine the size of the grouping/clustering image representing a POI group.

 @param count The number of POIs grouped into a cluster.
 @param clusterId The clusterId that size is requested for.
 @return size.
 */
@optional
- (CGSize)getImageSizeForLocationClusterWithCount:(NSUInteger)count clusterId:(NSString*)clusterId;

/**
 Callback for synchronously providing an image for a POI group (aka POI cluster).
 If both the async and sync variants of this method is implemented, the asynchronous variant is used.

 @param locationCluster List of grouped POIs.
 @param imageSize The image size to return.
 @param clusterId clusterId of the POI group.
 @return YES if the image request is accepted, essentially promising to call the completion block at some point in the future.
 @return NO if the image request will not be fulfilled by the completion handler. Returning NO make the map show the default grouping image.
 */
@optional
- (nullable UIImage*) getImageForLocationCluster:(NSArray<MPLocation*>*)locationCluster imageSize:(CGSize)imageSize clusterId:(NSString*)clusterId;

/**
 Callback for asynchronously providing an image for a POI group (aka POI cluster).

 @param locationCluster List of grouped POIs.
 @param imageSize The image size to return.
 @param clusterId clusterId of the POI group.
 @param completion completion handler to deliver the image.
 @return YES if the image request is accepted, essentially promising to call the completion block at some point in the future.
 @return NO if the image request will not be fulfilled by the completion handler. Returning NO make the map show the default grouping image.
 */
@optional
- (BOOL)getImageForLocationCluster:(NSArray<MPLocation*>*)locationCluster imageSize:(CGSize)imageSize clusterId:(NSString*)clusterId completion:(void(^)(UIImage* _Nullable image))completion;

/**
 Called when MPMapControl receives a new position update.

 @param positionResult The position result as estimated or calculated by a MPPositionProvider
 */
@optional
- (void)onPositionUpdate:(MPPositionResult*)positionResult;

/**
 Called when MPMapControl receives a location update.

 @param locations The locations that will be updated
 */
@optional
- (void)willUpdateLocationsOnMap:(NSArray<MPLocation*>*)locations NS_SWIFT_NAME(willUpdateLocationsOnMap(locations:));

/**
 Called when an error occurs in MPMapControl. The error code will reveal what kind of error was emitted. kMPErrorCode  definitions.

 @param error The error object.
 */
@optional
- (void)onError:(NSError*)error;

@end


#pragma mark - MPMapControl


/**
 Convenience class for setting up a Google map with MapsIndoors venues, buildings, locations and other map content.
 */
@interface MPMapControl : NSObject<MPFloorSelectorDelegate, MPVenueProviderDelegate, MPPositionProviderDelegate>

/**
  Delegate object containing data events
 */
@property (nonatomic, weak, nullable) id<MPMapControlDelegate> delegate;

/**
  Custom floor selector for the map to use.
  When provided, the MapControl will not create a floor selector control autonomously.
 @deprecated Use -floorSelector instead.
 */
@property (nonatomic, strong, nullable) id<MPFloorSelectorProtocol>       customFloorSelector DEPRECATED_MSG_ATTRIBUTE("Use -floorSelector instead.");

/**
  Floor selector UI element.
 
  If you need a customized floor selector beyond what MPFloorSelectorControl provides,
  or need finer control over location and visibility of the floor selector, 
  a custom floor selector can be provided to the MapControl by implementing the MPFloorSelectorProtocol protocol.
  If a custom floor selector is not provided, MPMapControl will create a default floor selector, MPFloorSelectorControl.
 
 */
@property (nonatomic, strong, nullable) id<MPFloorSelectorProtocol> floorSelector;

/**
  Hide floor selector UI element.
  Only applies to default floor selector; if a custom floor selector is provided, the MapControl is not repsonsible for it's visibility.
 */
@property (nonatomic) BOOL floorSelectorHidden;
/**
 Current single location selection.
 */
@property (nonatomic, nullable) MPLocation* selectedLocation;
/**
 The current floor.
 */
@property (nonatomic, nullable) NSNumber* currentFloor;
/**
 The map style.
 */
@property (nonatomic, nullable) MPMapStyle* mapStyle;
/**
 The venue name, at which the map should target its view.
 */
@property (nonatomic, nullable) NSString* venue;

/**
 Indicates whether or not basic data for the map has been loaded.
 This does *not* indicate whether maptiles have been loaded and displayed.
 */
@property (nonatomic, readonly) BOOL mapContentReady;

// TODO: Make this private once the structure is more stable.
/**
 Indicator for which map service to utilize.
 */
@property (nonatomic, nonnull) id<MPMapConfig> mapConfig;

/**
  Initialize a MPMapControl object with given configuration.
  @param mapConfig The configuration providing information to build the map control from.
 */
- (nullable instancetype)initWithMapConfig:(id<MPMapConfig>) mapConfig;

/**
 Setup the venue map with default providers based on MapsIndoors.solutionId.
 @param venueName The MapsPeople site id, used for locations and routing.
 */
- (void)setupMapWithVenue:(NSString*)venueName;

/**
  Get the location that wraps the given marker.
 */
- (nullable MPLocation*)getLocation;

/**
  Get location by string id reference.
 */
- (nullable MPLocation*)getLocationById:(NSString*) idString;

#pragma mark Selection and Filtering
/**
  Show a given set of locations. The display will override any zoom level condition made from display rules. Clear the locations by calling again with
  `clearFilter`.
 @param filter The filter object to apply to the map.
 @param behavior The filter behavior. Use `MPFilterBehavior.default` to get the default behavior.
 */
- (void)filter:(MPFilter*)filter behavior:(MPFilterBehavior*) behavior;
/**
  Show a given set of locations. The display will override any zoom level condition made from display rules. Clear the locations by calling again with
  `clearFilter`.
 @param locations The Locations that will be exclusively shown to the map.
 @param behavior The filter behavior. Use `MPFilterBehavior.default` to get the default behavior.
 */
- (void)filterWithLocations:(NSArray<MPLocation*>*)locations behavior:(MPFilterBehavior*) behavior;
/**
  Clears a given set of filtered locations. The display settings will revert to it's original appearance, however the map will remain static.
 */
- (void)clearFilter;
/**
  Selects and highlights a Location on the map using specified selection behavior.
 @param location The Location that will be selected.
 @param behavior The selection behavior. Use `MPSelectionBehavior.default` to get the default behavior.
 */
- (void)selectLocation:(MPLocation*)location behavior:(MPSelectionBehavior*)behavior;

/**
  Selects and highlights a Location with given id on the map using specified selection behavior.
 @param locationId The id of the Location that will be selected.
 @param behavior The selection behavior. Use `MPSelectionBehavior.default` to get the default behavior.
 */
- (void)selectLocationWithId:(NSString*)locationId behavior:(MPSelectionBehavior*)behavior;

/**
  Clears a currently selected Location.
 */
- (void)deselectLocation;

#pragma mark - Display rule support

- (MPDisplayRule*)displayRuleForLocation:(MPLocation*)location;

/**
 Add a DisplayRule for a single Location.
 This DisplayRule takes precedence over the Type DisplayRule and default display rule.
 @param rule DisplayRule to use for the given Location.
 @param location Location that the DisplayRule should apply to.
 */
- (void)setDisplayRule:(MPDisplayRule*)rule forLocation:(MPLocation*)location;

/**
 Add a Display Rule for multiple Locations.
 This DisplayRule takes precedence over the Type DisplayRule and default display rule.
 @param rule DisplayRule to use for the given Locations.
 @param locations Locations that the DisplayRule should apply to.
 */
- (void)setDisplayRule:(MPDisplayRule*)rule forLocations:(NSArray<MPLocation*>*)locations;

/**
 Apply a named displayRule to the given MPLocation.
 If MPMapControl does not have a displayRule with the given name, no changes is applied.
 @param ruleName Name of displayRule to apply to location
 @param location MPLocation to apply displayRule to
 @since 3.7.0
 */
- (void)setDisplayRuleNamed:(NSString*)ruleName forLocation:(MPLocation*)location;

/**
 Get a Type DisplayRule by name.
 @param ruleName Name of Type DisplayRule to retrieve.
 @return nil or DisplayRule
 */
- (MPDisplayRule* _Nullable)displayRuleForTypeNamed:(NSString*)ruleName;

/**
 The display rule used by MapControl to highlight the selected Location.
 Created and added by MapControl during initialization.
 Modify this DisplayRule to change the visual appearance of the Location highlight.
 */
@property (nonatomic, strong, readonly) MPDisplayRule*      locationHighlightDisplayRule;

/**
 The default DisplayRule used by MPMapControl to display a Location if no other values are available (defined in the MapsIndoors CMS).
 It is provided only for informational purposes and changes to this DisplayRule will have no effect on how a Location is displayed.
 */
@property (nonatomic, strong, readonly, nullable) MPDisplayRule* defaultDisplayRule;


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
 Returns whether halo is enabled for map labels.
 */
+ (BOOL)isMapLabelHaloEnabled;

/**
 Set the font that MapsIndoors should use when rendering labels on the map, and enable or disable white halo for improved visibility.
 */
+ (void)setMapLabelFont:(UIFont * _Nullable)mapLabelFont showHalo:(BOOL)showHalo;

/**
 Controls whether overlapping map markers can be resolved by grouping some of the overlapping items.
 Default value is NO;
 When set to YES, the default behavior is to group MPLocation's of the same type.
 */
@property (class) BOOL locationClusteringEnabled;

/**
 Controls whether overlapping map markers can be resolved by hiding some of the overlapping items.
 Default value is YES;
 */
@property (class) BOOL locationHideOnIconOverlapEnabled;

/**
 Overall range reserved for MapsIndoors use.
 */
@property (readonly) NSRange zIndexRangeForMapsIndoorsOverlays;

/**
 zIndex range reserved for polygon overlays managed by the MapsIndoors.
 */
@property (readonly) NSRange zIndexRangeForPolygonOverlays;

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
@property (readonly) NSRange zIndexRangeForMapsIndoorsTileLayers;


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
- (void)goTo:(MPLocation*)location;
/**
 Focus the map on the Location with given id.

 @param locationId The id of the Location to show on the map.
 */
- (void)goToLocationWithId:(NSString *)locationId;

/**
 Make sure the complete geometry of the given MPLocation is visible on the map.
 If the location is fully visible, the visible area of the map is unchanged.
 If the location is not fully visible, the map is centered around the location, and if needed zoomed.
 This method does not change the shown floor.
 The maps current bearing and vieweing angle is preserved.

 @param location Location to show.
 */
- (void)showAreaOfLocation:(MPLocation*)location;


#pragma mark - Accessibility support

/**
 The accessibility label associated with the user location marker on the map.
 Default: "My Location"
 */
@property (nonatomic, strong, nullable) NSString* userLocationAccessibilityLabel;

/**
 The accessibility label associated with the user location accuracy circle on the map.
 Default: "My location, accuracy %@m"
 */
@property (nonatomic, strong, nullable) NSString* userLocationAccuracyAccessibilityLabel;

@end

NS_ASSUME_NONNULL_END
