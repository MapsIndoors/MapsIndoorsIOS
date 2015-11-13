//
//  MapViewController.m
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 10/08/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import "MapViewController.h"
#import "Global.h"
#import <MapsIndoorsSDK/MapsIndoorsSDK.h>
#import <MaterialControls/MDButton.h>
#import "UIColor+AppColor.h"
#import <VCMaterialDesignIcons/VCMaterialDesignIcons.h>
#import "HorizontalDirectionsController.h"
#import "FloatingActionMenuController.h"

#define kDirectionsContainerHeight 180
#define kRouteFromHere @"Route from here"
#define kRouteToHere @"Route to here"

@interface MapViewController ()

@end

@implementation MapViewController {
    GMSMapView *_mapView;
    MPMapControl *_mapControl;
    UIView* _statusBarView;
    POIData* _locations;
    UIView* _directionsContainer;
    UIView* _floatingActionMenuContainer;
    GMSMarker* _longPressMarker;
    MPLocation* _origin;
    MPLocation* _destination;
    MPDirectionsRenderer* _directionsRenderer;
    MPMyLocationButton* _myLocationBtn;
    UIImage* _closeImg;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:_mapControl.loader selector:@selector(startAnimating) name:@"LocationsRequestStarted" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocationsReady:) name:@"LocationsDataReady" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocationDetailsReady:) name:@"LocationDetailsReady" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(renderRouteLeg:) name:@"RouteLegSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHorizontalDirections:) name:@"ShowHorizontalDirections" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNearest:) name:@"ShowNearest" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeRouting:) name:@"CloseRouting" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRouteResultReady:) name:@"RoutingDataReady" object:nil];
    
    _closeImg = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_close fontSize:24].image;
}

#pragma mark 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    MPFloorSelectorControl.selectedColor = [UIColor appPrimaryColor];
    
    _locations = Global.poiData;
    
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:Global.initialPosition.lat
                                                            longitude:Global.initialPosition.lng
                                                                 zoom:18.91];
    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    //_mapView.myLocationEnabled = YES;
    self.view = _mapView;
    
    _mapView.delegate = self;
    
    _mapControl = [[MPMapControl alloc] initWithMap:_mapView];
    
    [_mapControl setupMapWith: Global.solutionId site: Global.venue];
    
    _mapControl.delegate = self;
    
    //self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_menu fontSize:20].image
                                                                             style:self.splitViewController.displayModeButtonItem.style
                                                                            target:self.splitViewController.displayModeButtonItem.target
                                                                            action:self.splitViewController.displayModeButtonItem.action
                                             ];
    
    _longPressMarker = [[GMSMarker alloc] init];
    _longPressMarker.map = _mapView;
    _longPressMarker.icon = [UIImage imageNamed:@"Mylocation"];
    _origin = [[MPLocation alloc] init];
    _destination = [[MPLocation alloc] init];
    
    _directionsRenderer = [[MPDirectionsRenderer alloc] init];
    _directionsRenderer.delegate = self;
    _directionsRenderer.map = _mapView;
    _directionsRenderer.solidColor = [UIColor appDarkPrimaryColor];
    _directionsRenderer.backgroundColor = [[UIColor appLightPrimaryColor] colorWithAlphaComponent:0.5];
    _directionsRenderer.nextRouteLegButton = [[MPMapRouteLegButton alloc] init];
    _directionsRenderer.nextRouteLegButton.backgroundColor = [UIColor appAccentColor];
    [_directionsRenderer.nextRouteLegButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_directionsRenderer.nextRouteLegButton addTarget:self action:@selector(showNextRouteLeg) forControlEvents:UIControlEventTouchUpInside];
    [_directionsRenderer.previousRouteLegButton addTarget:self action:@selector(showPreviousRouteLeg) forControlEvents:UIControlEventTouchUpInside];
    
    
    [_mapControl addObserver:self forKeyPath:@"currentPosition.floor" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    int floor = [_mapControl.currentPosition.floor intValue];
    _mapControl.currentFloor = [NSNumber numberWithInt:floor];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.viewDidAppearCalled = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor appPrimaryColor];
    
    FloatingActionMenuController* famc = [[FloatingActionMenuController alloc] init];
    _floatingActionMenuContainer = famc.view;
    //_floatingActionMenuContainer.frame = CGRectMake(self.view.frame.size.width-80, self.view.frame.size.height-80, 60, 60);
    _floatingActionMenuContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [self addChildViewController:famc];
    [_mapView addSubview:_floatingActionMenuContainer];
    
    //NSLog(@"(%f, %f)", self.view.frame.size.width-80, self.view.frame.size.height-80);
    
    
    HorizontalDirectionsController* hdc = [[HorizontalDirectionsController alloc] init];
    _directionsContainer = hdc.view;
    _directionsContainer.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, kDirectionsContainerHeight);
    [self addChildViewController:hdc];
    [_mapView addSubview:_directionsContainer];
    _directionsContainer.layer.zPosition = 99999999;
    
    NSDictionary* viewsDictionary = @{@"fabView":_floatingActionMenuContainer};
    // Define the views Positions
    
    NSArray *constraint_POS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[fabView(60)]-16-|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewsDictionary];
    
    NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[fabView(60)]-16-|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:viewsDictionary];
    
    [self.view addConstraints:constraint_POS_V];
    [self.view addConstraints:constraint_POS_H];
    
    
    _myLocationBtn = [[MPMyLocationButton alloc] init];
    _myLocationBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_myLocationBtn addTarget:self action:@selector(showCurrentPosition:) forControlEvents:UIControlEventTouchUpInside];
    
    [_mapView addSubview:_myLocationBtn];
    
    NSArray *constraint_BPOS_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-80-[btn]"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:@{@"btn":_myLocationBtn}];
    
    NSArray *constraint_BPOS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[btn]-4-|"
                                                                        options:0
                                                                        metrics:nil
                                                                          views:@{@"btn":_myLocationBtn}];
    
    [_mapView addConstraints:constraint_BPOS_V];
    [_mapView addConstraints:constraint_BPOS_H];
    
    self.viewWillAppearCalled = YES;
}

- (void)showCurrentPosition: (id) sender {
    if (_mapControl.currentPosition.marker.position.latitude != 0.0f) {
        [_mapView animateToCameraPosition:[GMSCameraPosition cameraWithTarget:_mapControl.currentPosition.marker.position zoom:19]];
        int floor = _mapControl.currentPosition.geometry.z;
        _mapControl.currentFloor = [NSNumber numberWithInt:floor];
    }
}

- (void)showHorizontalDirections:(NSNotification*)notification {
    if (Global.routingData.latestRoute.legs.count > 1) {
        [UIView animateWithDuration:.3 animations:^{
            //_mapView.frame = CGRectMake(_mapView.frame.origin.x, _mapView.frame.origin.y, _mapView.frame.size.width, _mapView.frame.size.height-kDirectionsContainerHeight);
            _directionsContainer.frame = CGRectMake(_directionsContainer.frame.origin.x, _mapView.frame.size.height-kDirectionsContainerHeight, _directionsContainer.frame.size.width, _directionsContainer.frame.size.height);
                _floatingActionMenuContainer.layer.opacity = 0;
        }];
    } else {
        [UIView animateWithDuration:.3 animations:^{
            _directionsContainer.frame = CGRectMake(_directionsContainer.frame.origin.x, _mapView.frame.size.height-44, _directionsContainer.frame.size.width, _directionsContainer.frame.size.height);
                _floatingActionMenuContainer.layer.opacity = 0;
        }];
    }
}

- (void)hideHorizontalDirections:(NSNotification*)notification {
    [UIView animateWithDuration:.3 animations:^{
        //_mapView.frame = CGRectMake(_mapView.frame.origin.x, _mapView.frame.origin.y, _mapView.frame.size.width, _mapView.frame.size.height+kDirectionsContainerHeight);
        _directionsContainer.frame = CGRectMake(_directionsContainer.frame.origin.x, _mapView.frame.size.height, _directionsContainer.frame.size.width, _directionsContainer.frame.size.height);
        _floatingActionMenuContainer.layer.opacity = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void) getNearest:(NSNotification*)notification {
    MPLocationQuery* qObj = [[MPLocationQuery alloc] init];
    qObj.solutionId = Global.solutionId;
    qObj.near = Global.initialPosition;
    qObj.query = notification.object;
    qObj.max = 10;
    [_locations getLocationsUsingQueryAsync:qObj language:@"en"];
}

- (void)solutionDataReady:(MPSolution *)solution {
    for (MPType* type in solution.types) {
        [_mapControl addDisplayRule: [[MPLocationDisplayRule alloc] initWithName:type.name AndZoomLevelOn:19 AndShowLabel:NO]];
    }
    [_mapControl addDisplayRule: [[MPLocationDisplayRule alloc] initWithName:@"my-location" AndIcon: [UIImage imageNamed:@"Mylocation_direction"] AndZoomLevelOn:0 AndShowLabel:NO]];
    
    [_mapControl addPositionProvider:Global.positionProvider];
    
    [_mapControl showUserPosition:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SolutionDataReady" object:solution];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onLocationsReady:(NSNotification *)notification {
    [self closeRouting:nil];
    _mapControl.searchResult = notification.object;
    [_mapControl showSearchResult:YES];
    if (Global.poiData.locationQuery.types) {
        self.title = [NSString stringWithFormat:@"Search for '%@'", [[Global.poiData.locationQuery.types componentsJoinedByString:@", "] uppercaseString]];
    } else if (Global.poiData.locationQuery.query) {
        self.title = [NSString stringWithFormat:@"Search for '%@'", [Global.poiData.locationQuery.query uppercaseString]];
    } else {
        self.title = @"Search Result";
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:_closeImg style:UIBarButtonItemStylePlain target:self action:@selector(clearMap)];
}

- (void)clearMap {
    [_mapControl clearMap];
    _directionsRenderer.route = nil;
    self.navigationItem.rightBarButtonItem = nil;
    [self closeRouting:nil];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:Global.initialPosition.lat
                                                            longitude:Global.initialPosition.lng
                                                                 zoom:18.91];
    [_mapView animateToCameraPosition:camera];
    self.title = @"Map";
}

- (void)onLocationDetailsReady:(NSNotification *)notification {
    [self closeRouting:nil];
    _mapControl.selectedLocation = notification.object;
    self.title = _mapControl.selectedLocation.name;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:_closeImg style:UIBarButtonItemStylePlain target:self action:@selector(clearMap)];
}

- (void)floorDidChange:(NSNumber *)floor {
    _mapControl.currentFloor = floor;
}

- (void)renderRouteLeg:(NSNotification*)notification {
    self.title = @"Directions";
    if (notification.object) {
        _directionsRenderer.routeLegIndex = [notification.object intValue];
        [_directionsRenderer animate:5];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:_closeImg style:UIBarButtonItemStylePlain target:self action:@selector(clearMap)];
}

- (void)showNextRouteLeg {
    _directionsRenderer.routeLegIndex += 1;
    [_directionsRenderer animate:5];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowNextRouteLegInList" object:nil];
}
- (void)showPreviousRouteLeg {
    _directionsRenderer.routeLegIndex -= 1;
    [_directionsRenderer animate:5];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowPreviousRouteLegInList" object:nil];
}

- (void)closeRouting:(NSNotification*)notification {
    _directionsRenderer.route = nil;
    [self hideHorizontalDirections:nil];
    if (_mapControl.selectedLocation) {
        self.title = _mapControl.selectedLocation.name;
    }
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    mapView.selectedMarker = nil;
    if (marker == _longPressMarker) {
        if ([_longPressMarker.title isEqualToString:kRouteToHere]) {
            _destination.geometry = [[MPPoint alloc] initWithLat:marker.position.latitude lon:marker.position.longitude];
        } else {
            _origin.geometry = [[MPPoint alloc] initWithLat:marker.position.latitude lon:marker.position.longitude];
        }
        if (_origin.geometry && _destination.geometry) {
            [Global.routingData routingFrom:_origin to:_destination by:@"walking" avoid:nil depart:nil arrive:nil];
            _longPressMarker.position = CLLocationCoordinate2DMake(_origin.geometry.lat, _origin.geometry.lng);
            [self showHorizontalDirections:nil];
        }
    }
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {
    MPLocation* loc = [_mapControl getLocation:marker];
    if (loc) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MapLocationTapped" object:loc];
    }
    //Avoid default behavior
    return YES;
}

- (void)mapView:(GMSMapView *)mapView didLongPressAtCoordinate:(CLLocationCoordinate2D)coordinate {
    if ([_longPressMarker.title isEqualToString:kRouteFromHere]) {
        _longPressMarker.title = kRouteToHere;
    } else {
        _longPressMarker.title = kRouteFromHere;
    }
    _mapView.selectedMarker = _longPressMarker;
    _longPressMarker.position = coordinate;
}

- (void)onRouteResultReady:(NSNotification*) notification {
    _directionsRenderer.route = notification.object;
}

@end
