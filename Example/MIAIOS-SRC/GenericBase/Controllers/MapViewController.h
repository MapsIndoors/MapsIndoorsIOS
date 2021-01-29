//
//  MapViewController.h
//  MIAIOS
//
//  Created by Daniel Nielsen on 10/08/15.
//  Copyright (c) 2015-2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <MapsIndoors/MapsIndoors.h>


@interface MapViewController : UIViewController<MPMapControlDelegate, GMSMapViewDelegate, MPDirectionsRendererDelegate>

@property (strong, nonatomic) id            detailLocation;
@property (strong, nonatomic) GMSMapView*   mapView;
@property (nonatomic, strong) MPMapControl* mapControl;


@end

