//
//  MPLocation+Private.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 14/05/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPLocationDisplayRule.h"
#import "MPJSONModel.h"


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

@property (nonatomic, weak) id<MPLocationDisplayRuleDelegate> delegate;

- (BOOL)shouldShowPolygonAtZoom:(CGFloat)zLevel;

@end
