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

@protocol MPDirectionsRendererDelegate <NSObject>
/**
 * Floor change event.
 * @param The floor level.
 */
@optional
- (void) floorDidChange: (NSNumber*)floor; 
@end

typedef enum MPDirectionsRenderFit {
    MPDirectionsRenderFitIndoorPathFirstLineUpwards,
    MPDirectionsRenderFitIndoorPathUpwards,
    MPDirectionsRenderFitNorthBound
} MPDirectionsRenderFit;

@interface MPDirectionsRenderer : NSObject

@property (weak) id <MPDirectionsRendererDelegate> delegate;
/**
 Assigns (or unassigns) a Google map object
 */
@property (nonatomic, strong) GMSMapView* map;
/**
 Assigns (or unassigns) a route object
 */
@property (nonatomic, strong) MPRoute* route;
@property (nonatomic, strong) UIButton* nextRouteLegButton;
@property (nonatomic, strong) UIButton* previousRouteLegButton;
@property (nonatomic) NSInteger routeLegIndex;
@property (nonatomic) NSInteger routeStepIndex;

@property (nonatomic, strong) UIColor* solidColor;
@property (nonatomic, strong) UIColor* backgroundColor;
@property (nonatomic) BOOL fitBounds;
@property (nonatomic) MPDirectionsRenderFit fitMode;
@property (nonatomic) UIEdgeInsets edgeInsets;

- (void)animate:(NSTimeInterval)duration;


@end
