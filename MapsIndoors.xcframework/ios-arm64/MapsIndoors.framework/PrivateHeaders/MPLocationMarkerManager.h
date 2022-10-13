//
//  MPLocationMarkerManager.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 27/12/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>
#import "MPLocation+Private.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPLocationMarkerManager : NSObject

@property (nonatomic) BOOL      searchResultsShouldShowTypeIcon;        // Defaults to NO, so by default we will show the specific icons of the locations when showing search results
@property (readonly) NSRange    zIndexRangeForPolygonOverlays;

+ (instancetype) new NS_UNAVAILABLE;
- (instancetype) init NS_UNAVAILABLE;

+ (instancetype) newWithZIndexRangeForPolygonOverlays:(NSRange)range;
- (instancetype) initWithZIndexRangeForPolygonOverlays:(NSRange)range;

- (GMSMarker*)markerForLocation:(MPLocation*)location;
- (NSArray<GMSMarker*>*)managedMarkers;

- (BOOL) shouldLocation:(MPLocation*)location showAtZoomLevel:(CGFloat)zLevel;
- (BOOL) shouldLocation:(MPLocation*)location showAtZoomLevel:(CGFloat)zLevel floor:(int)floor;
- (BOOL) shouldLocation:(MPLocation*)location showAtFloor:(int)floor;

- (BOOL) shouldLocationShowPolygon:(MPLocation*)location atZoomLevel:(CGFloat)zLevel;
- (BOOL) shouldLocationShowPolygon:(MPLocation*)location atZoomLevel:(CGFloat)zLevel floor:(int)floor;

- (void)addLocation:(MPLocation*)location toMap:(GMSMapView *)map floor:(int)floor;

- (void)updateViewForLocation:(MPLocation*)location map:(GMSMapView*)map floor:(int)floor;

- (void)updateViewForLocation:(MPLocation*)location map:(GMSMapView*) map floor:(int)floor showAsSearchResult:(BOOL)showAsSearchResult;

- (void)removeLocationsByIds:(NSArray<NSString*>*)locationIds;

- (void)removeLocationFromMap:(MPLocation*)location;

- (NSString *)keyForLabelImageCache:(UIImage*)image label:(NSString*)label size:(CGSize)size;

- (CGFloat)getSizeFactorFor:(UIImage *)image otherImage:(UIImage *)other;

- (void) configureLocation:(MPLocation*)location forDisplayRule:(MPLocationDisplayRule*)displayRule;

- (BOOL)shouldLocation:(MPLocation*)location show2DModelAtZoomLevel:(CGFloat)zoomLevel floor:(int)floor;
- (void)updateLocation2DModelForLocation:(MPLocation*)location floor:(int)floor map:(GMSMapView*)map;

@end

NS_ASSUME_NONNULL_END
