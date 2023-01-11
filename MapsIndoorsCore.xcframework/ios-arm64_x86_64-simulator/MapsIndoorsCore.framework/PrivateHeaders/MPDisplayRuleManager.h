//
//  MPLocationMarkerManager.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 27/12/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MPLocation+Private.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPDisplayRuleManager : NSObject

- (BOOL)shouldLocation:(MPLocation *)location showAtZoomLevel:(CGFloat)zoomLevel;
- (BOOL)shouldLocation:(MPLocation *)location showAtZoomLevel:(CGFloat)zoomLevel floorIndex:(int)floor;
- (BOOL)shouldLocation:(MPLocation *)location showAtFloor:(int)floor;

- (BOOL)shouldLocationShowPolygon:(MPLocation *)location atZoomLevel:(CGFloat)zoomLevel;
- (BOOL)shouldLocationShowPolygon:(MPLocation *)location atZoomLevel:(CGFloat)zoomLevel floorIndex:(int)floor;

#pragma mark - New DisplayRule implementation for v4

@property (nonatomic, strong) MPDisplayRule* defaultDisplayRule;

- (void)buildDisplayRules;
- (MPDisplayRule*)displayRuleForLocation:(MPLocation*)location;
- (MPDisplayRule*)displayRuleForTypeNamed:(NSString*)typeName;
- (void)setDisplayRule:(MPDisplayRule*)rule forLocation:(MPLocation*)location;

@end

NS_ASSUME_NONNULL_END
