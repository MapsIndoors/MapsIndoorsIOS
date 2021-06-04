//
//  MPMapsConfig.h
//  MapsIndoorsCore
//
//  Created by Daniel Nielsen on 13/11/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPMapsConfig : NSObject

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
 Set the font that MapsIndoors should use when rendering labels on the map, and enable or disable white halo for improved visibility.
 */
+ (void)setMapLabelFont:(UIFont * _Nullable)mapLabelFont showHalo: (BOOL) showHalo;

/**
 Returns whether halo is enabled for map labels.
 */
+ (BOOL)isMapLabelHaloEnabled;

@end

NS_ASSUME_NONNULL_END
