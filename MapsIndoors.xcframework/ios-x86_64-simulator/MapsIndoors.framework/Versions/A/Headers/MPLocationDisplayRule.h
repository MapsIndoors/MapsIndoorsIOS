//
//  MPDisplayRule.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 7/30/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MPJSONModel.h"
#import "MPLocation.h"


@class MPLocation;


/**
 This class serves as a display rule for locations.
 */
@interface MPLocationDisplayRule : MPJSONModel

/**
 Name/identifier of the rule. Also used as the rule condition for the location types.
 */
@property (nonatomic, strong, nullable) NSString<Ignore>* name;

/**
 The map zoom level above which the location marker should be visible.
 */
@property (nonatomic, strong, nullable) NSNumber* zOn;

/**
 The map zoom level beneath which the location marker should be visible.
 */
@property (nonatomic, strong, nullable) NSNumber* zOff;

/**
 Relative path of the marker icon to use, without extension. Format is png.
 */
@property (nonatomic, strong, nullable) NSString* iconPath;

/**
 Label template for the resulting location marker - e.g. "{{name}}", "{{roomId}}", "Room #{{roomId}}" etc..
 */
@property (nonatomic, strong, nullable) NSString* label;

/**
 The highlight outline color.
 */
@property (nonatomic, strong, nullable) UIColor<Optional>* highlightOutlineColor;

/**
 The highlight fill color.
 */
@property (nonatomic) UIColor<Optional>* _Nullable highlightFillColor;

/**
 The highlight stroke width.
 */
@property (nonatomic) NSNumber<Optional>* _Nullable highlightStrokeWidth;

/**
 The marker icon to use on markers that apply to the display rule.
 */
@property (nonatomic, strong, nullable) UIImage<Ignore>* icon;

/**
 Whether or not to show a text label. See label property
 */
@property (assign, nonatomic) BOOL showLabel;

/**
 Whether or not to show an icon.
 */
@property (assign, nonatomic) BOOL showIcon;

/**
 Whether or not to show an outline.
 */
@property (assign, nonatomic) BOOL showOutline;

/**
 Whether or not to show the icon.
 */
@property (assign, nonatomic) BOOL visible;

/**
 Size of the icon image
 */
@property (assign, nonatomic) CGSize iconSize;

/**
 Processes the rule conditions at the given map zoom level.
 @param  zLevel The current map zoom level.
   @return Whether or not to show the location.
 */
- (BOOL)show:(CGFloat)zLevel;

/**
 Get the label from the display rule, based on the location input.
   @return An string.
 */
- (nullable NSString*)getLabelContent:(nonnull MPLocation*)location;

/**
 Retrieve the icon from the ressources and store in memory.
 */
- (void)fetchIcon: (nonnull NSString*) basePathOrBundle;

/**
 Instantiate a display rule with parameters.
 @param  name The name and identifier of the rule.
 @param  zOn The map zoom level above which the location marker should display.
 @param  doShowLabel Whether or not to show a text label instead of the icon.
 */
- (nullable instancetype)initWithName:(nullable NSString*) name AndZoomLevelOn: (CGFloat) zOn AndShowLabel:(BOOL) doShowLabel;

/**
 Instantiate a display rule with parameters.
 @param  name The name and identifier of the rule.
 @param  icon The icon used to display locations that qualify conditions of this rule.
 @param  zOn The map zoom level above which the location marker should display.
*/
- (nullable instancetype)initWithName:(nullable NSString*) name AndIcon: (nullable UIImage*) icon AndZoomLevelOn: (CGFloat) zOn;

/**
 Instantiate a display rule with parameters.
 @param  name The name and identifier of the rule.
 @param  icon The icon used to display locations that qualify conditions of this rule.
 @param  zOn The map zoom level above which the location marker should display.
 @param  doShowLabel Whether or not to show a text label instead of the icon.
 */
- (nullable instancetype)initWithName:(nullable NSString*) name AndIcon: (nullable UIImage*) icon AndZoomLevelOn: (CGFloat) zOn AndShowLabel:(BOOL) doShowLabel;

/**
 Defered instantiate a display rule with parameters.
 @param  name The name and identifier of the rule.
 @param  iconURL The icon URL used to display locations that qualify conditions of this rule.
 @param  zOn The map zoom level above which the location marker should display.
 @param  doShowLabel Whether or not to show a text label instead of the icon.
 */
- (nullable instancetype)initWithName:(nullable NSString*) name AndIconURL: (nullable NSString*) iconURL AndZoomLevelOn: (CGFloat) zOn AndShowLabel:(BOOL) doShowLabel;


#pragma mark - POI overlap resolution related properties (POI Grouping, clustering)

/**
 The grouping or clustering id of this displayrule.
 MPLocations sharing the same clusteringId may be grouped on the map if necessary.
 Default value is nil
 */
@property (nonatomic, strong, nullable) NSString<Optional>*   clusteringId;

/**
 Display rank determines which POI (or group of POIs) will be displayed in case of conflicts / overlaps.
 Higher ranks wins over lower.
 */
@property (nonatomic) NSInteger     displayRank;


#pragma mark - Polygon support

/**
 BOOL indicating if the locations polygon should be shown on the map.
 */
@property (nonatomic) BOOL   showPolygon;

/**
 The map zoom level above which the location polygon should be visible.
*/
@property (nonatomic, strong, nullable) NSNumber*   zOnPolygon;         // nullable float

/**
 The map zoom level beneath which the location marker should be visible.
 */
@property (nonatomic, strong, nullable) NSNumber*   zOffPolygon;        // nullable float

/**
 The stroke width of the polygon drawn on the map.
 */
@property (nonatomic, strong, nullable) NSNumber*   polygonStrokeWidth; // nullable float

/**
 The stroke color of the polygon drawn on the map.
 */
@property (nonatomic, strong, nullable) UIColor*    polygonStrokeColor;

/**
 The fill color of the polygon drawn on the map.
 */
@property (nonatomic, strong, nullable) UIColor*    polygonFillColor;


@end
