//
//  MapViewController.h
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 10/08/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <MapsIndoorsSDK/MapsIndoorsSDK.h>
#import "UIFont+SystemFontOverride.h"

@interface MapViewController : UIViewController<MPMapControlDelegate, MPLocationsProviderDelegate, GMSMapViewDelegate, MPDirectionsRendererDelegate>

@property (strong, nonatomic) id detailLocation;


@property (nonatomic, assign) BOOL viewDidAppearCalled;
@property (nonatomic, assign) BOOL viewWillAppearCalled;

@end

