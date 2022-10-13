//
//  MPLocationDisplayRule+Private.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 14/05/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "MapsIndoors/MPLocationDisplayRule.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MPLocationDisplayRuleDelegate;

@interface MPLocationDisplayRule ()

/**
 The scale of the location display rule icon.
 */
@property (nonatomic, strong) NSNumber<Optional>* imageScale;

/**
 When a displayRule-property that affect the display of MPLocations on a map is chaing, this value changes.
 KVO observable.
 */
@property (nonatomic) NSUInteger changeCountForPropertiesAffectingLocationDisplay;

/**
 Cache flag. If set to true the image rendered for a marker will be cached.
 */
@property (nonatomic) BOOL cacheRenderedImage;

/**
 Indicates whether the 'showPolygon' property has been set.
 */
@property (nonatomic) BOOL didSetShowPolygon;
@property (nonatomic) BOOL didSetModel2DVisible;

@property (nonatomic, weak) id<MPLocationDisplayRuleDelegate> delegate;

- (BOOL)shouldShowPolygonAtZoom:(CGFloat)zLevel;

- (void)observePropertiesAffectingLocationDisplay;
- (void)unobservePropertiesAffectingLocationDisplay;

#pragma mark - 2D Model support

@property (nonatomic, strong, nullable) NSNumber* model2DBearing;
@property (nonatomic, strong, nullable) NSNumber* model2DHeightMeters;
@property (nonatomic, strong, nullable) NSString* model2DModel;
@property (nonatomic, assign) BOOL model2DVisible;
@property (nonatomic, strong, nullable) NSNumber* model2DWidthMeters;
@property (nonatomic, strong, nullable) NSNumber* model2DZoomFrom;
@property (nonatomic, strong, nullable) NSNumber* model2DZoomTo;

- (void)model2DImage:(void(^)(UIImage* _Nullable))fetched;
- (BOOL)shouldShow2DModelAtZoom:(float)zoomLevel;

@end

NS_ASSUME_NONNULL_END
