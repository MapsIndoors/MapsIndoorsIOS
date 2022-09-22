//
//  MPDirectionsRenderer.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 01/10/15.
//  Copyright © 2015 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "MPRoute.h"

#define kMPNotificationDirectionsRenderingStarted @"MP_DIRECTIONS_RENDERING_STARTED"
#define kMPNotificationDirectionsRenderingStopped @"MP_DIRECTIONS_RENDERING_STOPPED"

#pragma mark - DirectionsRendererContextualInfoSettings

/// @enum MPDirectionsRendererContextualInfoScope
/// @brief Which information to show from the Location close to the end of a route leg.
typedef NS_ENUM(NSUInteger, MPDirectionsRendererContextualInfoScope) {
    /** Shows both icon and name of POI of defined type along the rendered route */
    MPDirectionsRendererContextualInfoScopeIconAndName,
    /** Shows only icon of POI of defined type along the rendered route */
    MPDirectionsRendererContextualInfoScopeIconOnly,
    /** Shows only name of POI of defined type along the rendered route */
    MPDirectionsRendererContextualInfoScopeNameOnly
};

/// Settings for showing contextual info along the rendered route
@interface MPDirectionsRendererContextualInfoSettings : NSObject
/// The Types of Location that should be used when showing text and icon for a start or end marker.
/// If no Types are supplied, all Types of Locations will be considered.
@property (nonatomic, nullable) NSArray<NSString*>* types;

/// The Categories of Location that should be used when showing text and icon for a start or end marker.
/// If no Categories are supplied, all Categories of Locations will be considered.
@property (nonatomic, nullable) NSArray<NSString*>* categories;

/// The maximum distance in meters allowed for using text and icon from a Location. Leave blank for a default of 5 meters.
@property (nonatomic) double maxDistance;

/// Which content should be used. Default is IconAndName.
@property MPDirectionsRendererContextualInfoScope contentScope;

@end

#pragma mark - Directions Renderer Delegate

/**
 Directions Renderer delegate protocol
 */
@protocol MPDirectionsRendererDelegate <NSObject>
/**
 Floor change event.
 @param floor The floor level.
 */
@optional
- (void) floorDidChange: (nonnull NSNumber*)floor; 
@end

typedef NS_ENUM(NSUInteger, MPDirectionsRenderFit) {
    /** Ensures that the first part of any indoor route leg/step that is longer than 1 meter is facing upwards. Outdoor route leg/step renders with north facing upwards. */
    MPDirectionsRenderFitIndoorPathFirstLineUpwards,
    /** Ensures that the direct line between start and end location of any indoor route leg/step is facing upwards. Outdoor route leg/step renders with north facing upwards. */
    MPDirectionsRenderFitIndoorPathUpwards,
    /** Renders the route leg/step with north facing upwards. */
    MPDirectionsRenderFitNorthBound
};

#pragma mark - Directions Renderer

/**
 Directions Renderer
 */
@interface MPDirectionsRenderer : NSObject

@property (nonatomic, weak, nullable) id <MPDirectionsRendererDelegate> delegate;
/**
 Assigns (or unassigns) a Google map object
 */
@property (nonatomic, strong, nullable) GMSMapView* map;
/**
 Assigns (or unassigns) a route object
 */
@property (nonatomic, strong, nullable) MPRoute* route;
/**
 Template button used to render a marker at the end of the rendered route leg
 */
@property (nonatomic, strong, nullable) UIButton* nextRouteLegButton;
/**
 Template button used to render a marker at the start of the rendered route leg
 */
@property (nonatomic, strong, nullable) UIButton* previousRouteLegButton;
/**
 Index of the route leg that will be rendered. If set to something negative, rendering will be disabled.
 */
@property (nonatomic) NSInteger routeLegIndex;
/**
 Optional index of the route step in the current route leg. If set, only the step will be rendered and not the current route leg. If set to something negative, route step rendering will be disabled.
 */
@property (nonatomic) NSInteger routeStepIndex;
/**
 Foreground color of the rendered route leg/step.
 */
@property (nonatomic, strong, nullable) UIColor* solidColor;
/**
 Background color of the rendered route leg/step. The background color will ne visible during animation.
 */
@property (nonatomic, strong, nullable) UIColor* backgroundColor;
/**
 If set to YES, the map viewport will be adjusted to fit the rendered route leg/step.
 */
@property (nonatomic) BOOL fitBounds;
/**
 Bounds fitting mode.
 */
@property (nonatomic) MPDirectionsRenderFit fitMode;
/**
 Intentional egde insets for bounds fitting. The rendering is not guaranteed to respect the specified insets.
 */
@property (nonatomic) UIEdgeInsets edgeInsets;
/**
 Indicates whether the renderer is currently showing a route or not.
 */
@property (nonatomic, readonly) BOOL    isRenderingRoute;
/**
 Custom images to use for representing the action points. The first image will be used as the start image. The image at position N in the array will be used at the end of the leg with index N-1, as well as the end of the last step of the leg with index N-1.
 */
@property (nonatomic, strong, nullable) NSArray<UIImage*>*  actionPointImages;

/**
 Start animation of the route leg/step with given duration. Starting with a `backgroundColor` route leg/step the polyline will be gradually stroked from start to end with the `solidColor` at the speed of `leg/step length / duration`.

 @param duration Duration in seconds.
 */
- (void)animate:(NSTimeInterval)duration;

/**
 Set this property to show labels and icons from nearby Locations as additional contextual information about the start and end positions of the rendered route segment.
 */
@property (nonatomic, nullable) MPDirectionsRendererContextualInfoSettings* contextualInfoSettings;

@end

