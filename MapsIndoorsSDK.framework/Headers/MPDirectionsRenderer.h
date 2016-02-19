//
//  MPDirectionsRenderer.h
//  MapsIndoorSDK
//
//  Created by Daniel Nielsen on 01/10/15.
//  Copyright © 2015 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#ifdef USE_M4B
#import <GoogleMapsM4B/GoogleMaps.h>
#else
#import <GoogleMaps/GoogleMaps.h>
#endif
#import "MPRoute.h"

@protocol MPDirectionsRendererDelegate <NSObject>
/**
 * Floor change event.
 * @param RoutingCollection The Routing data collection.
 */
@optional
- (void) floorDidChange: (NSNumber*)floor;
@end



@interface MPDirectionsRenderer : NSObject

@property (weak) id <MPDirectionsRendererDelegate> delegate;

@property (nonatomic, strong) GMSMapView* map;
@property (nonatomic, strong) MPRoute* route;
@property (nonatomic, strong) UIButton* nextRouteLegButton;
@property (nonatomic, strong) UIButton* previousRouteLegButton;
@property (nonatomic) NSInteger routeLegIndex;

@property (nonatomic, strong) UIColor* solidColor;
@property (nonatomic, strong) UIColor* backgroundColor;
@property (nonatomic) BOOL fitBounds;
@property (nonatomic) UIEdgeInsets edgeInsets;

- (void)animate:(NSTimeInterval)duration;


@end
