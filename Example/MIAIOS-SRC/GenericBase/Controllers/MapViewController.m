//
//  MapViewController.m
//  MIAIOS
//
//  Created by Daniel Nielsen on 10/08/15.
//  Copyright (c) 2015-2018 MapsPeople A/S. All rights reserved.
//

#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <MapsIndoors/MapsIndoors.h>
#import <VCMaterialDesignIcons/VCMaterialDesignIcons.h>

#import "Global.h"
#import "HorizontalRoutingController.h"
#import "UIColor+AppColor.h"
#import "FloatingActionMenuController.h"
#import "SectionModel.h"
#import "BeaconPositionProvider.h"
#import "UIViewController+Custom.h"
#import "LocalizedStrings.h"
#import <PureLayout/PureLayout.h>
#import <KVOController/NSObject+FBKVOController.h>
#import "VenueSelectorController.h"
#import "Tracker.h"
#import "UIViewController+LocationServicesAlert.h"
#import "MyLocationButton.h"
#import "MPMapButton.h"
#import "MPToastView.h"
#import "NSObject+MPNetworkReachability.h"
#import "MPMapInfoView.h"
#import "MPAccessibilityHelper.h"
#import "MPMapRouteTrackingModel.h"
//#import "SimulatedPeopleLocationSource.h"
#import "BuildingInfoCache.h"
#import "AppVariantData.h"
#import "AppNotifications.h"


#define kRouteFromHere @"Route from here"
#define kRouteToHere @"Route to here"

#define kViewingAngleObservePath        @"camera.viewingAngle"
#define kMaxViewingAngleForTurnByTurn   45

#define kZoomObservePath @"camera.zoom"
#define kHasAppliedZoomHint @"MI_HAS_APPLIED_HINT"


typedef NS_ENUM( NSUInteger, StackLayoutIndex ) {
    
    StackLayoutIndex_Map,
    StackLayoutIndex_HorizontalDirections,
    StackLayoutIndex_Toast,
};

@interface MapViewController () < MPCategoriesProviderDelegate
                                , MPMapRouteTrackingModelDelegate
                                , MPLiveDataManagerDelegate >

@property (nonatomic, weak) NSLayoutConstraint*                     horizontalDirectionsHeightConstraint;
@property (nonatomic, strong) HorizontalRoutingController*          horizontalRoutingController;
@property (nonatomic) BOOL                                          enableHorizontalDirectionsDisplay;

@property (nonatomic) BOOL                                          venueSelectorIsShowing;
@property (nonatomic, strong) NSTimer*                              floorSelectorVisibilityTimer;

@property (nonatomic) BOOL                                          didConnectPositionProviderToMapControl;
@property (nonatomic, weak) UIAlertController*                      locationServicesAlert;

@property (nonatomic) BOOL                                          disableFloorSelectorControl;
@property (nonatomic, strong) UIView*                               floorSelectorSuperview;
@property (nonatomic, weak, readonly) MPFloorSelectorControl*       floorSelector;

@property (nonatomic, strong) MyLocationButton*                     myLocationBtn;

@property (nonatomic, strong) MPCategoriesProvider*                 categoriesProvider;
@property (nonatomic, strong) NSDictionary<NSString*,NSString*>*    categoriesMap;

@property (nonatomic, weak) UIView*                                 fabDimmingOverlay;
@property (weak, nonatomic) IBOutlet UIStackView*                   stackView;
@property (nonatomic, weak) MPToastView*                            toastView;

@property (nonatomic) BOOL                                          mapDidInitialize;

@property (nonatomic, weak) UIImageView*                            customCompass;
@property (nonatomic) CLLocationDegrees                             customCompassBearing;

@property int                                                       displayQueryCounter;
@property int                                                       displayQueryValidationCount;

@property (nonatomic, strong) MPMapRouteTrackingModel*              mapRouteTrackingModel;
@property (nonatomic) BOOL                                          enterTurnByTurnModeOnNextRouteRendering;

@property (nonatomic, strong) MPLocationQuery*                      localLocationQuery;

@property (nonatomic, strong) MPLocation*                           focusedBuilding;
@property (nonatomic, weak) MPVenue*                                autoSelectedInitialVenue;

@property (nonatomic) BOOL                                          userGestureInProgress;

@property (nonatomic) BOOL                                          suspendTrackingOnVenueChange;

@property (nonatomic, strong) UIView*                               statusBarView;
@property (nonatomic, strong) UIView*                               directionsContainer;
@property (nonatomic, strong) UIView*                               floatingActionMenuContainer;
@property (nonatomic, strong) FloatingActionMenuController*         floatingActionMenuController;
@property (nonatomic, strong) MPLocation*                           origin;
@property (nonatomic, strong) MPLocation*                           destination;
@property (nonatomic, strong) MPDirectionsRenderer*                 directionsRenderer;
@property (nonatomic, strong) GMSCameraPosition *                   camera;
@property (nonatomic, strong) UIImage*                              closeImg;
@property (nonatomic) UIInterfaceOrientation                        currentOrientation;
@property (nonatomic) BOOL                                          keepMapCameraOnce;
@property (nonatomic, strong) MPVenueProvider*                      venueProvider;
@property (nonatomic, strong) UIView *                              shadeView;
@property (nonatomic, strong) UIButton*                             zoomHintBtn;
@property (nonatomic, strong) UIButton*                             returnToVenueOrLocationBtn;

@property (nonatomic) BOOL                                          shouldShowFloorSelector;

@property (nonatomic, strong) NSArray<NSString*>*                   activeLiveDataDomains;

@property (nonatomic, weak) UILabel*        debugInfoLabel;

@end


@implementation MapViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.suspendTrackingOnVenueChange = YES;
    if ( [AppVariantData sharedAppVariantData].mapShouldTrackUserLocationOnAppLaunch ) {
        self.suspendTrackingOnVenueChange = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.suspendTrackingOnVenueChange = YES;
        });
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocationsReady:) name:@"LocationsDataReady" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLocationOnMap:) name:@"ShowLocationOnMap" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(renderRouteLeg:) name:kNotificationRouteLegSelected object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showOnMap:) name:@"ShowOnMap" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeRouting:) name:@"CloseRouting" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openDirectionsSettings:) name:@"OpenDirectionsSettings" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRouteResultReady:) name:@"RoutingDataReady" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onVenueChanged:) name:@"VenueChanged" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fabOpening:) name:@"FABWillOpen" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fabClosing:) name:@"FABWillClose" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(venueSelectorDidAppear:) name:kNotificationVenueSelectorDidAppear object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(venueSelectorDidDisappear:) name:kNotificationVenueSelectorDidDisappear object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMenuOpenOrClose:) name:kNotificationMenuOpenClose object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectPositionProviderToMapControl) name:kNotificationPositioningInitialized object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableHorizontalDirections) name:@"EnableHorizontalDirections" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disableHorizontalDirections) name:@"DisableHorizontalDirections" object:nil];
    
    _closeImg = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_close fontSize:24].image;
    
    [self.KVOController observe:self.horizontalRoutingController keyPath:@"verticalMode" options:NSKeyValueObservingOptionNew block:^(MapViewController* _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        if (Global.routingData.latestRoute) {
            [observer showHorizontalDirections:nil];
        }
    }];

    _shadeView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    MPFloorSelectorControl.selectedColor = [UIColor colorFromHexString:@"#CFCFCF"];
    MPFloorSelectorControl.selectedFloorButtonTitleColor = [UIColor darkGrayColor];
    MPFloorSelectorControl.userFloorColor = [UIColor appTertiaryHighlightColor];
    
    if (Global.initialPosition) {
        _camera = [GMSCameraPosition cameraWithLatitude:Global.initialPosition.lat
                                                            longitude:Global.initialPosition.lng
                                                                 zoom:Global.initialPosition.zIndex];
    }
    [self setupMapView];
    if ( _mapView == nil ) {
        return;
    }

    self.mapControl = [[MPMapControl alloc] initWithMap:_mapView];
    self.mapControl.currentFloor = [NSNumber numberWithInt:Global.initialPosition.zIndex];
    self.mapControl.delegate = self;
    self.mapControl.userLocationAccessibilityLabel = kLangUserLocationMarkerAccLabel;
    self.mapControl.userLocationAccuracyAccessibilityLabel = kLangUserLocationAccuracyAccLabel;
    
//    [self.mapControl addDisplayRule:SimulatedPeopleLocationSource.peopleDisplayRule];
//    [self.mapControl addDisplayRule:SimulatedPeopleLocationSource.currentUserDisplayRule];

    if (_floatingActionMenuContainer == nil) {
        
        [self setupFAB];
        [self setupHorizontalDirections];
    }
    if (_zoomHintBtn == nil) {
        [self setupZoomButtons];
    }

    [self setupMyLocationButton];
    [self setupCustomFloorSelector];

    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    BOOL    menuIsOpen = self.splitViewController.displayMode != UISplitViewControllerDisplayModePrimaryHidden;
    [self updateMenuButtonImage: menuIsOpen];
    
    _origin = [[MPLocation alloc] init];
    _destination = [[MPLocation alloc] init];
    
    [self setupDirectionsRenderer];
    
    self.venueSelectorIsShowing = VenueSelectorController.venueSelectorIsShown;
    
    _venueProvider = [MPVenueProvider new];
    [self.categoriesProvider getCategories];
    
    _displayQueryCounter = 0;
    _displayQueryValidationCount = 0;

    [self.KVOController observe:self.mapControl keyPath:@"selectedLocation" options:NSKeyValueObservingOptionNew block:^(MapViewController* _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        [observer updateReturnToVenueBtnText];
        [observer updateReturnToVenueBtnVisibility];
    }];

    [self updateDebugInfoLabel];
    
    //Live Data
    MPLiveDataManager.sharedInstance.delegate = self;
    
    [MPLiveDataManager.sharedInstance updateLiveDataInfo];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    [Tracker trackScreen:@"Map"];
    
    __weak typeof(self)weakSelf = self;
    [self mp_onReachabilityChange:^(BOOL isNetworkReachable) {
        if ( isNetworkReachable == NO ) {
            
            [weakSelf showToastMessage:kLangNoInternetUnableToUpdateMap buttonTitle:nil buttonClickHandler:nil];
            
        } else {
            
            [weakSelf hideToastMessage];
            if ( weakSelf.mapDidInitialize == NO ) {
                [weakSelf.mapControl setupMapWithVenue: Global.venue.name];
            }
        }
    }];

    self.navigationController.navigationBar.barTintColor = [UIColor appPrimaryColor];
    
    self.venueSelectorIsShowing = VenueSelectorController.venueSelectorIsShown;
}

- (void) orientationDidChange: (NSNotification*) notification {
    UIInterfaceOrientation o = [[UIApplication sharedApplication] statusBarOrientation];
    if (_currentOrientation != o) {
        [self closeFloatingActionMenu];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
            [self setupOnAppearance];
            //rerender directions if necessary
            if (_directionsRenderer.map) {
                _directionsRenderer.map = _mapView;
            }
        }
    }
    _currentOrientation = o;
}

- (void) viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self setupOnAppearance];
}


#pragma mark - Setup methods for various views

- (void)setupDirectionsRenderer {
    _directionsRenderer = [[MPDirectionsRenderer alloc] init];
    _directionsRenderer.delegate = self;
    _directionsRenderer.map = _mapView;
    _directionsRenderer.fitMode = MPDirectionsRenderFitIndoorPathFirstLineUpwards;
    _directionsRenderer.solidColor = [UIColor appRouteHighlightColor];
    _directionsRenderer.backgroundColor = [[UIColor appRouteHighlightColor] colorWithAlphaComponent:0.5];
    _directionsRenderer.nextRouteLegButton = [[MPMapRouteLegButton alloc] init];
    _directionsRenderer.nextRouteLegButton.backgroundColor = [UIColor appAccentColor];
    [_directionsRenderer.nextRouteLegButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_directionsRenderer.nextRouteLegButton addTarget:self action:@selector(showNextRouteLeg) forControlEvents:UIControlEventTouchUpInside];
    [_directionsRenderer.previousRouteLegButton addTarget:self action:@selector(showPreviousRouteLeg) forControlEvents:UIControlEventTouchUpInside];
    _directionsRenderer.edgeInsets = UIEdgeInsetsMake(40, 30, 40, 30);
}

- (float)getBottomOffset {
    float bottomOffset = 0;
    UIWindow* window = UIApplication.sharedApplication.keyWindow;
    if (@available(iOS 11.0, *)) {
        bottomOffset = window.safeAreaInsets.bottom;
    }
    return bottomOffset;
}

- (void)setupFAB {

    _floatingActionMenuController = [[FloatingActionMenuController alloc] init];
    _floatingActionMenuContainer = _floatingActionMenuController.view;
    
    [self addChildViewController:_floatingActionMenuController];
    [self.view addSubview:_floatingActionMenuContainer];
    
    float bottomOffset = [self getBottomOffset];
    
    [_floatingActionMenuContainer autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_mapView withOffset:-32 - bottomOffset];
    [_floatingActionMenuContainer autoPinEdge:ALEdgeRight  toEdge:ALEdgeRight  ofView:_mapView withOffset:-8];
}

- (void)setupHorizontalDirections {
    
    self.horizontalRoutingController = (HorizontalRoutingController *)[self.storyboard instantiateViewControllerWithIdentifier:@"HorizontalRoutingController"];
    _directionsContainer = _horizontalRoutingController.view;
    _directionsContainer.frame = CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, [self heaightForDirectionsPanel]);
    
    [self addChildViewController:_horizontalRoutingController];
    
    [self.stackView insertArrangedSubview:_directionsContainer atIndex:MIN(StackLayoutIndex_HorizontalDirections,self.stackView.arrangedSubviews.count)];
    _directionsContainer.hidden = YES;
    
    self.horizontalDirectionsHeightConstraint = [_directionsContainer autoSetDimension:ALDimensionHeight toSize:[self heaightForDirectionsPanel]];
}

- (void)setupMapView {
    if (_mapView == nil) {
        @try {
            GMSCameraPosition*  cam = _camera ?: [[GMSCameraPosition alloc] initWithTarget: CLLocationCoordinate2DMake(0, 0) zoom:8];       // Get or create cameraposition; -[GMSMapView mapWithFrame:camera:] requires a nonnull camera as of v3.x
            _mapView = [GMSMapView mapWithFrame:self.view.bounds camera:cam];
        } @catch (NSException *exception) {
            return;
        }
    }
    
    [self.stackView addArrangedSubview:_mapView];
    
    _mapView.accessibilityElementsHidden = NO;
    
    _mapView.buildingsEnabled = NO;
    
    _mapView.delegate = self;
    _mapView.settings.compassButton = YES;
    
    // Load map-styling from variant-specific plist or from standard styling (gmap_style.json):
    NSString* mapStyleString = [Global getPropertyFromPlist:@"GoogleMapsStyle"];
    if ( mapStyleString == nil ) {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"gmap_style" ofType:@"json"];
        mapStyleString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    }
    if (mapStyleString) {
        NSError* err = nil;
        GMSMapStyle* mapStyle = [GMSMapStyle styleWithJSONString:mapStyleString error:&err];
        if (err == nil) {
            _mapView.mapStyle = mapStyle;
        }
    }
}

- (void)setupZoomButtons {
    _returnToVenueOrLocationBtn = [MPMapButton buttonWithType:UIButtonTypeSystem];
    [_returnToVenueOrLocationBtn setTitle:kLangReturnToVenue forState:UIControlStateNormal];
    [_returnToVenueOrLocationBtn addTarget:self action:@selector(returnToVenue) forControlEvents:UIControlEventTouchUpInside];
    _returnToVenueOrLocationBtn.alpha = 0;

    if ([[NSUserDefaults standardUserDefaults] objectForKey:kHasAppliedZoomHint] == nil) {
        _zoomHintBtn = [MPMapButton buttonWithType:UIButtonTypeSystem];
        [_zoomHintBtn setTitle:kLangZoomForMoreDetails forState:UIControlStateNormal];
        [_zoomHintBtn addTarget:self action:@selector(zoomIn) forControlEvents:UIControlEventTouchUpInside];
        [_mapView addSubview:_zoomHintBtn];
        [_mapView addObserver:self forKeyPath:kZoomObservePath options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }

    [_mapView addObserver:self forKeyPath:kViewingAngleObservePath options:NSKeyValueObservingOptionNew context:nil];
}

- (void) setupOnAppearance {
    
    if ( _mapView == nil ) {
        return;
    }

    // Restore selected venue from last session if available:
    NSString* venueId = [[NSUserDefaults standardUserDefaults] objectForKey:@"venue"];
    if (venueId.length) {
        [_venueProvider getVenueWithId:venueId completionHandler:^(MPVenue *venue, NSError *error) {
            
            if ( venue && ([venue.venueKey.lowercaseString isEqualToString:self.mapControl.venue.lowercaseString] == NO) ) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"VenueChanged" object:venue];
            }
        }];
    }

    // No previously selected venue, select either solution default venue or the first venue in the venue list as fallback:
    if (venueId.length == 0 && self.mapControl.venue == nil) {

        [_venueProvider getVenuesWithCompletion:^(MPVenueCollection * _Nullable venueCollection, NSError * _Nullable error) {

            NSArray<MPVenue>*   venues = venueCollection.venues;
            __block MPVenue*    initialVenue = venueCollection.venues.firstObject;

            [[MPAppDataProvider new] getAppDataWithCompletion:^(MPAppData *appData, NSError *error) {

                NSString* defaultVenue = [appData.appSettings objectForKey:@"defaultVenue"];
                if ( defaultVenue.length ) {
                    for ( MPVenue* v in venues ) {
                        if ( [v.venueId isEqualToString:defaultVenue] ) {
                            initialVenue = v;
                            break;
                        }
                    }
                }

                if ( initialVenue ) {
                    self.autoSelectedInitialVenue = initialVenue;
                    self.mapControl.venue = initialVenue.venueKey;
                    [self zoomToVenue:initialVenue];
                }
            }];
        }];
    }

    self.venueSelectorIsShowing = VenueSelectorController.venueSelectorIsShown;
    
    [self setupCustomMapCompass];   // Uses safeAreaInsets, so has to be done when view is in view-hierarchy.
}


#pragma mark -

- (void)setVenueSelectorIsShowing:(BOOL)venueSelectorIsShowing {
    
    _venueSelectorIsShowing = venueSelectorIsShowing;
    
    if ( _venueSelectorIsShowing ) {

        if ( self.floorSelector.superview ) {
            self.floorSelectorSuperview = self.floorSelector.superview;
            [self.floorSelector removeFromSuperview];
        }
        
        [self.floorSelectorVisibilityTimer invalidate];
        self.floorSelectorVisibilityTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(onVenueSelectorTimer:) userInfo:nil repeats:YES];
        
    } else {
    
        [self.floorSelectorVisibilityTimer invalidate];
        self.floorSelectorVisibilityTimer = nil;
        
        if ( self.floorSelectorSuperview ) {
            [self setupCustomFloorSelector];
            self.floorSelectorSuperview = nil;
        }
    }
}

- (void) onVenueSelectorTimer:(NSTimer*)timer {
    dispatch_async( dispatch_get_main_queue(), ^{
        if ( self.mapControl ) {
            self.venueSelectorIsShowing = VenueSelectorController.venueSelectorIsShown;
        }
    });
}

- (void)toggleLocationTracking: (id) sender {
    
    if ( self.myLocationBtn.trackingButtonState != TrackingButtonState_Disabled ) {

        [self.mapRouteTrackingModel toggleTrackingMode];

        [self updateMapTrackingUI:NO];
    }
    
    if ( MapsIndoors.positionProvider.locationServicesActive == NO ) {
        [self locationServicesCheck];
    }

    [Tracker trackEvent:@"Map_Blue_Dot" parameters:nil];
}

- (void) updateMapTrackingUI:(BOOL)userGestureTrigger {

    TrackingButtonState newTrackingButtonState = self.myLocationBtn.trackingButtonState;

    switch ( self.mapRouteTrackingModel.trackingState ) {
        case MPMapTrackingState_Suspended:
            newTrackingButtonState = self.mapRouteTrackingModel.trackingMode == MPMapTrackingMode_FollowWithHeading
                                   ? TrackingButtonState_TrackingLocationAndHeadingSuspended
                                   : TrackingButtonState_Enabled;
            break;
        case MPMapTrackingState_NotTracking:
            newTrackingButtonState = TrackingButtonState_Enabled;
            break;
        case MPMapTrackingState_Following:
            newTrackingButtonState = TrackingButtonState_TrackingLocation;
            break;
        case MPMapTrackingState_FollowingWithHeading:
            newTrackingButtonState = TrackingButtonState_TrackingLocationAndHeading;
            break;
    }

    BOOL    didChangeState = newTrackingButtonState != self.myLocationBtn.trackingButtonState;

    if ( didChangeState ) {

        self.myLocationBtn.trackingButtonState = newTrackingButtonState;

        switch ( newTrackingButtonState ) {
            case TrackingButtonState_TrackingLocationAndHeading:
            case TrackingButtonState_TrackingLocation:
                _directionsRenderer.fitBounds = NO;
                break;

            case TrackingButtonState_Enabled:
            case TrackingButtonState_Disabled:
            case TrackingButtonState_TrackingLocationAndHeadingSuspended:
                if ( userGestureTrigger == NO ) {           // When triggered by a user gesture on the map, we do not force fit the current route leg
                    _directionsRenderer.fitBounds = YES;
                }
                break;
        }
    }

    [self updateCompass];

    UIEdgeInsets    targetPadding;
    if ( self.mapRouteTrackingModel.isTracking && self.mapRouteTrackingModel.turnByTurnMode ) {
        CGFloat topPadding = _mapView.bounds.size.height * 0.5;
        targetPadding = UIEdgeInsetsMake( topPadding, 0, 0, 0 );
    } else {
        targetPadding = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    UIEdgeInsets    currentPadding = _mapView.padding;
    if ( UIEdgeInsetsEqualToEdgeInsets( targetPadding, currentPadding) == NO ) {
        _mapView.padding = targetPadding;
    }

    [self updateScreenSleepConfig];
}

- (void) updateScreenSleepConfig {

    BOOL    disableScreenSleep = [UIApplication sharedApplication].isIdleTimerDisabled;

    switch ( self.mapRouteTrackingModel.trackingState ) {
        case MPMapTrackingState_Suspended:
        case MPMapTrackingState_NotTracking:
            disableScreenSleep = NO;
            break;
        case MPMapTrackingState_Following:
        case MPMapTrackingState_FollowingWithHeading:
            disableScreenSleep = self.mapRouteTrackingModel.turnByTurnMode;
            break;
    }

    if ( disableScreenSleep != [UIApplication sharedApplication].isIdleTimerDisabled ) {
        NSLog( @"[I] %@ screen sleep", disableScreenSleep ? @"Disabling" : @"Enabling" );
        [UIApplication sharedApplication].idleTimerDisabled = disableScreenSleep;
    }
}

- (void) enableHorizontalDirections {

    if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone ) {
        if ( self.enableHorizontalDirectionsDisplay == NO ) {
            self.enableHorizontalDirectionsDisplay = YES;
        }
    }
}

- (void) disableHorizontalDirections {

    if ( self.enableHorizontalDirectionsDisplay == YES ) {
        self.enableHorizontalDirectionsDisplay = NO;
        
        [self hideHorizontalDirections:nil];
    }
}
- (void)showHorizontalDirections:(NSNotification*)notification {
    
    if ( self.enableHorizontalDirectionsDisplay ) {
        
        self.horizontalDirectionsHeightConstraint.constant = [self heaightForDirectionsPanel];
        
        if ( _directionsContainer.hidden == YES ) {
            
            [UIView animateWithDuration:.3 animations:^{
                self->_directionsContainer.hidden = NO;
                [self.stackView layoutIfNeeded];
                self->_floatingActionMenuContainer.layer.opacity = 0;
            }];
        }
    }
}

- (void)hideHorizontalDirections:(NSNotification*)notification {
    
    if ( _directionsContainer.hidden == NO ) {
        
        [UIView animateWithDuration:.3 animations:^{
            [self.stackView layoutIfNeeded];
            self->_directionsContainer.hidden = YES;
            self->_floatingActionMenuContainer.layer.opacity = 1;
        }];
    }
}

- (void) showOnMap:(NSNotification*)notification {
    [Tracker trackScreen:@"Show Search on Map"];

    [self.mapRouteTrackingModel suspendTracking];

    MPLocationQuery* qObj = [[MPLocationQuery alloc] init];
    qObj.categories = @[notification.object];
    qObj.venue = Global.venue.venueKey;
    [MapsIndoors.locationsProvider getLocationsUsingQuery:qObj completionHandler:^(MPLocationDataset * _Nullable locationData, NSError * _Nullable error) {
        if ( !error ) {
            self.localLocationQuery = qObj;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LocationsDataReady" object: locationData.list];
        }
    }];
}

- (void)refreshMyLocationGraphic {
    NSString* myLocationImageName = MapsIndoors.positionProvider.latestPositionResult.headingAvailable
                                  ? [AppVariantData sharedAppVariantData].imageNameForBlueDotWithHeading
                                  : [AppVariantData sharedAppVariantData].imageNameForBlueDot;
    MPLocationDisplayRule* rule = [[MPLocationDisplayRule alloc] initWithName:@"my-location" AndIcon: [UIImage imageNamed:myLocationImageName] AndZoomLevelOn:0 AndShowLabel:NO];
    rule.iconSize = CGSizeMake(32, 32);
    [self.mapControl setDisplayRule: rule];
}

- (void)solutionDataReady:(MPSolution *)solution {
    
    [self refreshMyLocationGraphic];
    
    [self.mapControl showUserPosition:YES];
    
    Global.solution = solution;
    [AppNotifications postSolutionDataReadyNotificationWithSolution:solution];
    self.venueSelectorIsShowing = VenueSelectorController.venueSelectorIsShown;
}

- (void) mapContentReady {

    MPSolutionProvider* solutionProvider = [MPSolutionProvider new];
    [solutionProvider getSolutionWithCompletion:^(MPSolution * _Nullable solution, NSError * _Nullable error) {
        if ( solution ) {
            [self solutionDataReady:solution];
        }
    }];

    self.mapDidInitialize = YES;
}

- (void)onLocationsReady:(NSNotification *)notification {

    [self.mapRouteTrackingModel suspendTracking];
    [self closeRouting:nil];
    
    if (notification.object || Global.locationQuery.query.length > 0 || Global.locationQuery.types || Global.locationQuery.categories) {
        _displayQueryCounter++;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                if (++self->_displayQueryValidationCount == self->_displayQueryCounter) {
                
                    NSArray* searchResults = notification.object;
                    
                    //For the moment it does not make sense to show a "cloud" of locations
                    if (searchResults.count > 300) {
                        searchResults = [searchResults subarrayWithRange:NSMakeRange(0, 300)];
                    }
                    
                    self.mapControl.searchResult = searchResults;
                    MPLocation* firstLoc = self.mapControl.searchResult.firstObject;
                    self.mapControl.currentFloor = firstLoc.floor;
                    [self.mapControl showSearchResult:YES];

                    MPLocationQuery*    activeQuery = self.localLocationQuery ?: Global.locationQuery;

                    if (activeQuery.categories) {
                        NSArray<NSString*>* names = [self categoryNamesFromKeys:activeQuery.categories];
                        self.title = [names componentsJoinedByString:@", "];
                    } else if (activeQuery.types) {
                        self.title = [NSString stringWithFormat:kLangSearchingForVar, [[activeQuery.types componentsJoinedByString:@", "] uppercaseString]];
                    } else if (activeQuery.query.length > 0) {
                        self.title = [NSString stringWithFormat:kLangSearchingForVar, [activeQuery.query uppercaseString]];
                    } else {
                        self.title = kLangSearchResult;
                    }

                    self.localLocationQuery = nil;
                    
                    [self setupClearMapButton];
                }
            });
        });
        
    } else {
        self.title = Global.venue.name;
        [self.mapControl clearMap];
        _directionsRenderer.route = nil;
        self.mapRouteTrackingModel.route = nil;
        [self removeClearMapButton];
    }
    
    [self updateCompass];
}

- (void) setupClearMapButton {
    
    UIImage*    clearImage = [UIImage imageNamed:@"CloseSmall"];
    UIButton*   button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake( 0, 0, 22, 22 );
    button.accessibilityLabel = kLangClearMap;
    [button setImage:clearImage forState:UIControlStateNormal];

    if ( [UIDevice currentDevice].systemVersion.floatValue < 11 ) {
        [button sizeToFit];     // Without this bar button items do not appear on iOS 10 (and it is not necessary on iOS11+)
    }
    
    [button addTarget:self action:@selector(clearMap) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*    clearMapButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    // Add a spacing item - without there will be no space to the title on small screens (or long titles).
    UIBarButtonItem* spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spacer.width = 1;
    spacer.isAccessibilityElement = NO;     // Dont alert voiceover user to item as it only exists to make a *visual* spacing
    
    self.navigationItem.rightBarButtonItems = @[ clearMapButton, spacer ];

    [self updateReturnToVenueBtnText];
    [self updateReturnToVenueBtnVisibility];
}

- (void) removeClearMapButton {
    
    self.navigationItem.rightBarButtonItems = nil;
}

- (void)enableLiveData {
    for (NSString* domainType in self.activeLiveDataDomains) {
        [self.mapControl enableLiveData:domainType];
    }
}

- (void)disableLiveData {
    for (NSString* domainType in self.activeLiveDataDomains) {
        [self.mapControl disableLiveData:domainType];
    }
}

- (void)clearMap {
    if ( VenueSelectorController.venueSelectorIsShown == NO ) {
        [self setupCustomFloorSelector];
    }
    [self.mapControl clearMap];
    _mapView.selectedMarker = nil;
    _directionsRenderer.route = nil;
    self.mapRouteTrackingModel.route = nil;
    [self removeClearMapButton];
    [self closeRouting:nil];
    self.title = Global.venue.name;
    [self closeFloatingActionMenu];
    UIViewController *currentSidebarVC = self.splitViewController.viewControllers.firstObject.childViewControllers.lastObject;
    [currentSidebarVC.navigationController.topViewController popToMasterViewControllerAnimated:YES];
    self.venueSelectorIsShowing = VenueSelectorController.venueSelectorIsShown;
    [self updateCompass];
    [self updateMapTrackingUI:NO];
    [self updateReturnToVenueBtnText];
    [self updateReturnToVenueBtnVisibility];
}

- (void)showLocationOnMap:(NSNotification *)notification {
    [self.mapRouteTrackingModel suspendTracking];
    [self closeRouting:nil];
    [self setupClearMapButton];
    _destination = notification.object;
    self.mapControl.searchResult = nil;
    self.mapControl.currentFloor = _destination.floor;
    self.mapControl.selectedLocation = notification.object;
    self.title = self.mapControl.selectedLocation.name;
    if (!_keepMapCameraOnce) {
        //TODO: Why is this delay needed?
        __weak typeof(self)weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            MPLocation*                     location = weakSelf.destination;
            NSString*                       locationType = location.type;
            NSArray<MPPolygonGeometry*>*    polys = [MPGeometryHelper polygonsForLocation:location];

            if ( polys.count && ([locationType isEqualToString:@"VENUE"] || [locationType isEqualToString:@"BUILDING"]) ) {

                GMSCoordinateBounds*    bbox = [GMSCoordinateBounds new];

                for ( MPPolygonGeometry* poly in polys ) {
                    bbox = [bbox includingBounds: [[GMSCoordinateBounds alloc] initWithPath:poly.gmsPathForPath]];
                }

                [weakSelf.mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bbox withPadding:30.0f]];

            } else {

                CLLocationCoordinate2D locationTargetCoord = CLLocationCoordinate2DMake(weakSelf.destination.geometry.lat, weakSelf.destination.geometry.lng);
                GMSCameraPosition* pos = [GMSCameraPosition cameraWithTarget:locationTargetCoord zoom:19];
                weakSelf.mapView.camera = pos;
            }
        });
    } else {
        _keepMapCameraOnce = NO;
    }
    self.venueSelectorIsShowing = VenueSelectorController.venueSelectorIsShown;
}

- (void)floorDidChange:(NSNumber *)floor {
    if ([MapsIndoors.positionProvider class] == [BeaconPositionProvider class]) {
        ((BeaconPositionProvider*)MapsIndoors.positionProvider).floor = floor;
    }
    self.mapControl.currentFloor = floor;

    if ( [floor isEqualToNumber:@( (int)MapsIndoors.positionProvider.latestPositionResult.geometry.z)] == NO ) {
        [self.mapRouteTrackingModel suspendTracking];
    }

    [Tracker trackEvent:@"Map_Floor_Selector_Clicked" parameters:@{ @"floorIndex" : floor }];
}

- (BOOL) allowAutomaticSwitchToFloor:(NSNumber *)toFloor {
    
    return (_directionsRenderer == nil) || (_directionsRenderer.route == nil);
}

- (void)renderRouteLeg:(NSNotification*)notification {
    
    if (notification.userInfo) {
        
        NSInteger legIndex = [[notification.userInfo objectForKey:kLegIndex] integerValue];
        NSInteger stepIndex = [[notification.userInfo objectForKey:kStepIndex] integerValue];
        NSString* accessibilityLabel = notification.userInfo[kRouteSectionAccessibilityLabel];
        
        if (notification.object) {

            if ( self.enterTurnByTurnModeOnNextRouteRendering ) {
                self.mapRouteTrackingModel.turnByTurnMode = YES;
                self.enterTurnByTurnModeOnNextRouteRendering = NO;
                
            } else {

                [self.mapRouteTrackingModel suspendTracking];
                if ( _directionsRenderer.fitBounds == NO ) {
                    _directionsRenderer.fitBounds = YES;
                }
            }

            self.mapControl.searchResult = nil;
            [self.floorSelector removeFromSuperview];
            self.title = kLangGetDirections;
            if ( notification.userInfo[kRouteSectionImages] ) {
                _directionsRenderer.actionPointImages = notification.userInfo[kRouteSectionImages];
            }
            _directionsRenderer.routeLegIndex = legIndex;
            _directionsRenderer.routeStepIndex = stepIndex;
            _directionsRenderer.accessibilityLabel = accessibilityLabel;
            [_directionsRenderer animate:4];

            [self setupClearMapButton];

            MPRouteLeg* leg = [_directionsRenderer.route.legs objectAtIndex:_directionsRenderer.routeLegIndex];
            NSNumber*   legFloor = ((MPRouteStep*)leg.steps.firstObject).end_location.zLevel;
            NSNumber*   destinationFloor = _destination.floor;

            if (  (_directionsRenderer.route.legs.count > _directionsRenderer.routeLegIndex + 1)
               || ([destinationFloor compare:legFloor] != NSOrderedSame) ) {
                self.mapControl.selectedLocation = nil;
            } else {
                self.mapControl.selectedLocation = _destination;
            }
            
            [UIView animateWithDuration:.3 animations:^{
                self->_floatingActionMenuContainer.layer.opacity = 0;
            }];
            
            [self updateCompass];
            
        }
    }
}

- (void)showNextRouteLeg {
    [self.floorSelector removeFromSuperview];
    _directionsRenderer.routeLegIndex += 1;
    [_directionsRenderer animate:4];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowNextRouteLegInList" object:nil];
    if (_directionsRenderer.route.legs.count > _directionsRenderer.routeLegIndex + 1) {
        self.mapControl.selectedLocation = nil;
    } else {
        self.mapControl.selectedLocation = _destination;
    }
    MPRouteLeg* leg = [_directionsRenderer.route.legs objectAtIndex:_directionsRenderer.routeLegIndex];
    self.mapControl.currentFloor = ((MPRouteStep*)leg.steps.firstObject).end_location.zLevel;
}

- (void)showPreviousRouteLeg {
    if ( _directionsRenderer.routeLegIndex > 0 ) {
        [self.floorSelector removeFromSuperview];
        _directionsRenderer.routeLegIndex -= 1;
        [_directionsRenderer animate:4];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowPreviousRouteLegInList" object:nil];
        if (_directionsRenderer.route.legs.count > _directionsRenderer.routeLegIndex + 1) {
            self.mapControl.selectedLocation = nil;
        } else {
            self.mapControl.selectedLocation = _destination;
        }
        if ( _directionsRenderer.routeLegIndex >= 0 ) {
            MPRouteLeg* leg = [_directionsRenderer.route.legs objectAtIndex:_directionsRenderer.routeLegIndex];
            self.mapControl.currentFloor = ((MPRouteStep*)leg.steps.firstObject).end_location.zLevel;
        }
    }
}

- (void)closeRouting:(NSNotification*)notification {
    
    if ( VenueSelectorController.venueSelectorIsShown == NO ) {
        [self setupCustomFloorSelector];
    }
    _directionsRenderer.route = nil;
    self.mapRouteTrackingModel.route = nil;
    if (self.horizontalRoutingController)
    {
        [self.horizontalRoutingController clearData];
    }
    [self hideHorizontalDirections:nil];
    if (self.mapControl.selectedLocation) {
        self.title = self.mapControl.selectedLocation.name;
    }
    self.venueSelectorIsShowing = VenueSelectorController.venueSelectorIsShown;
    self.disableFloorSelectorControl = NO;
    
    [UIView animateWithDuration:.3 animations:^{
        self->_floatingActionMenuContainer.layer.opacity = 1;
    }];
    
    [self updateCompass];
}

- (void) openDirectionsSettings:(NSNotification*)notification {
    self.disableFloorSelectorControl = YES;
    [self toggleSidebar];
}

- (void) updateCameraToLeg: (int)legIndex {
    if (_directionsRenderer.route.legs.count > legIndex && legIndex > 0) {
        MPRouteLeg* leg = [_directionsRenderer.route.legs objectAtIndex:legIndex];
        CLLocationDirection heading = GMSGeometryHeading(CLLocationCoordinate2DMake([leg.start_location.lat doubleValue], [leg.start_location.lng doubleValue]), CLLocationCoordinate2DMake([leg.end_location.lat doubleValue], [leg.end_location.lng doubleValue]));
        [_mapView animateToBearing:heading];
    }
}


#pragma mark - GMSMapViewDelegate, MPMapControlDelegate

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker {

    UIView*     infoView;
    id          thing = [_mapControl getLocation:marker] ?: marker.userData;

    if ( [thing isKindOfClass:[MPLocation class]] ) {
        MPLocation* model = thing;
        infoView = [MPMapInfoView createMapInfoWindowForLocation:model];
        [infoView autoSetDimension:ALDimensionWidth toSize:mapView.bounds.size.width * 0.66 relation:NSLayoutRelationLessThanOrEqual];
    }
    
    return infoView;
}

- (UIView*) infoWindowForLocationCluster:(NSArray<MPLocation *> *)locations {

    NSString*   firstName = locations.firstObject.name;
    if ( firstName.length >= 15 ) {
        firstName = [NSString stringWithFormat:@"%@...", [firstName substringToIndex:15]];
    }
    NSString* info = [NSString stringWithFormat:@"%@ +%@", firstName, @(locations.count -1)];
    MPLocationUpdate* locUpdate = [MPLocationUpdate updateWithLocation:locations.firstObject];
    locUpdate.name = info;
    MPLocation* fakeLocation = locUpdate.location;

    UIView*     infoView;
    infoView = [MPMapInfoView createMapInfoWindowForLocation:fakeLocation];
    [infoView autoSetDimension:ALDimensionWidth toSize:self.mapView.bounds.size.width * 0.66 relation:NSLayoutRelationLessThanOrEqual];

    return infoView;
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker {
    
    if ( _directionsRenderer.isRenderingRoute == NO ) {   // Dont open POI details when in routing mode.
        
        mapView.selectedMarker = nil;
        MPLocation* loc = [self.mapControl getLocation:marker];
        if (loc) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MapLocationTapped" object:loc];
            _keepMapCameraOnce = YES;
        }
    }
}

- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker {

    [self.mapRouteTrackingModel suspendTracking];

    MPLocation* loc = [self.mapControl getLocation:marker];
    if (loc) {
        CLLocationCoordinate2D  oldCameraTarget = self.mapView.camera.target;   // Remember current camera...
        self.mapControl.selectedLocation = loc;
        [self.mapView animateToLocation:oldCameraTarget];                       // ... so we can restore the camera position (to circumvent centering the POI/marker).

        [Tracker trackEvent:kMPEventNameTappedLocationOnMap parameters:@{ @"Location": loc.name, @"Zoom_Level" : @(_mapView.camera.zoom)}];
        
        // If voiceover mode, go directly to full info (as it seems impossible to make the infowindow accessible):
        if ( UIAccessibilityIsVoiceOverRunning() ) {
            [self mapView:mapView didTapInfoWindowOfMarker:marker];
        }
    }
    //Avoid default behavior
    return loc != nil; //YES;
}

- (BOOL) didTapAtCoordinate:(CLLocationCoordinate2D)coordinate withLocations:(NSArray<MPLocation *> *)locations {
    
    MPLocation* selectedLocation = locations.firstObject;
    
    if ( selectedLocation ) {
        [Tracker trackEvent:kMPEventNameTappedLocationOnMap parameters:@{ @"Location": selectedLocation.name, @"Zoom_Level" : @(_mapView.camera.zoom)}];
    }
    
    return YES;     // YES: Enable default selection and highlight provided by MPMapControl.
}

- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position {

    [self.mapRouteTrackingModel mapView:mapView idleAtCameraPosition:position];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    
        // Make the floor selector appear only when we're zoomed in to where building content is "pretty legible":
        CGFloat     floorSelectorAlphaForCurrentZoomLevel = (self->_mapView.camera.zoom < 15) || (self.shouldShowFloorSelector == NO) ? 0 : 1;
        if ( self.floorSelector.alpha != floorSelectorAlphaForCurrentZoomLevel ) {
            [UIView animateWithDuration:0.3 animations:^{
                self.floorSelector.alpha = floorSelectorAlphaForCurrentZoomLevel;
            }];
        }
    });

    self.userGestureInProgress = NO;
}

- (void) mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position {
    
    self.customCompassBearing = _mapView.camera.bearing;
}

- (void) mapView:(GMSMapView*)mapView willMove:(BOOL)gesture {

    self.userGestureInProgress = YES;

    [self.mapRouteTrackingModel mapView:mapView willMove:gesture];

    if ( gesture == YES ) {
        self.shouldShowFloorSelector = YES;
    }
}

- (void) focusedBuildingDidChange:(MPLocation *)building {

    self.focusedBuilding = building;
    [self updateReturnToVenueBtnVisibility];
}


#pragma mark - Notifications

- (void)onRouteResultReady:(NSNotification*) notification {
    self.directionsRenderer.route = notification.object;
    self.venueSelectorIsShowing = VenueSelectorController.venueSelectorIsShown;
    self.mapRouteTrackingModel.route = _directionsRenderer.route;
    if (self.mapRouteTrackingModel.isTurnByTurnApplicable) {
        self.enterTurnByTurnModeOnNextRouteRendering = YES;
    }

    self.destination = notification.userInfo[ AppNotifications.routeRequestDestinationKey ];
}

- (void)onVenueChanged:(NSNotification*) notification {

    if ( self.suspendTrackingOnVenueChange ) {
        [self.mapRouteTrackingModel suspendTracking];
    }

    Global.venue = notification.object;
    self.mapControl.venue = Global.venue.venueKey;
    self.mapControl.currentFloor = Global.venue.defaultFloor ?: @(0);

    [self zoomToVenue:Global.venue];
    self.title = Global.venue.name;
    
    self.venueSelectorIsShowing = VenueSelectorController.venueSelectorIsShown;

    _returnToVenueOrLocationBtn.alpha = 0;
    self.autoSelectedInitialVenue = nil;

    self.shouldShowFloorSelector = NO;
}

- (void) fabOpening:(NSNotification*) notification {

    [Tracker trackEvent:@"Map_Fab_Opened" parameters:nil];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self hideCustomFloorSelector];
        self.myLocationBtn.alpha = 0;
        self.fabDimmingOverlay.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:.7];
        
    } completion:^(BOOL finished) {
        [self.floorSelector removeFromSuperview];
    }];
}

- (void) fabClosing:(NSNotification*) notification {
    
    [self setupCustomFloorSelector];
    [self showCustomFloorSelector];

    [UIView animateWithDuration:0.3 animations:^{
        self.myLocationBtn.alpha = 1;
        self.fabDimmingOverlay.backgroundColor = [UIColor clearColor];
        
    } completion:^(BOOL finished) {
        [self.fabDimmingOverlay removeFromSuperview];
    }];
}

- (void) venueSelectorDidAppear:(NSNotification*) notification {
    
    dispatch_async( dispatch_get_main_queue(), ^{
        [self clearMap];
        self.venueSelectorIsShowing = VenueSelectorController.venueSelectorIsShown;
    });
}

- (void) venueSelectorDidDisappear:(NSNotification*) notification {
    
    self.venueSelectorIsShowing = VenueSelectorController.venueSelectorIsShown;
}

- (void) onMenuOpenOrClose:(NSNotification*) notification {
    
    BOOL    menuIsOpen = [notification.userInfo[ kNotificationMenuOpenClose_IsOpenKey] boolValue];
    
    if ( [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad ) {
        
        [self updateMenuButtonImage:menuIsOpen];
        
    } else {
        
        if (menuIsOpen) {
            
            [self.navigationController.view addSubview:_shadeView];
            
            [UIView animateWithDuration:0.5f animations:^{
                [self->_shadeView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:.75]];
            }];
            
            [self hideHorizontalDirections:nil];
            
        } else {
            
            [UIView animateWithDuration:0.5f animations:^{
                [self->_shadeView setBackgroundColor:[UIColor clearColor]];
            } completion:^(BOOL finished) {
                [self->_shadeView removeFromSuperview];
            }];
            
            if (self.mapControl.selectedLocation != nil) {
                [Tracker trackScreen:@"Show Location on Map"];
            }
            
            if ( _directionsRenderer.isRenderingRoute ) {
                [self showHorizontalDirections:nil];
            }
        }
    }
}


#pragma mark - FAB Handling, Dimming View

- (void) closeFloatingActionMenu {

    [_floatingActionMenuController closeFloatingActionMenu];
}

- (UIView*) fabDimmingOverlay {
    
    UIView* v = _fabDimmingOverlay;
    
    if ( (v == nil) && _mapView ) {
        _fabDimmingOverlay = v = [[UIView alloc] initWithFrame: _mapView.frame];
        _fabDimmingOverlay.opaque = NO;
        _fabDimmingOverlay.alpha = 1;
        _fabDimmingOverlay.backgroundColor = [UIColor clearColor];
        [_floatingActionMenuContainer.superview addSubview:_fabDimmingOverlay];
        [_floatingActionMenuContainer.superview bringSubviewToFront:_floatingActionMenuContainer];
        
        BOOL    dimOnlyMap = NO;
        if ( dimOnlyMap ) {
            [_fabDimmingOverlay autoPinEdge:ALEdgeLeft   toEdge:ALEdgeLeft   ofView:_mapView];
            [_fabDimmingOverlay autoPinEdge:ALEdgeRight  toEdge:ALEdgeRight  ofView:_mapView];
            [_fabDimmingOverlay autoPinEdge:ALEdgeTop    toEdge:ALEdgeTop    ofView:_mapView];
            [_fabDimmingOverlay autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:_mapView];

        } else {
            [_fabDimmingOverlay autoPinEdgesToSuperviewEdges];
        }

        _fabDimmingOverlay.userInteractionEnabled = YES;
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeFloatingActionMenu)];
        [_fabDimmingOverlay addGestureRecognizer:singleTap];
    }
    
    return v;
}


#pragma mark - Misc

- (void) updateMenuButtonImage:(BOOL) menuIsOpen {

    BOOL    isIPad     = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;

    UIImage*    img = menuIsOpen && isIPad
                    ? [UIImage imageNamed:@"fullscreen"]
                    : [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_menu fontSize:20].image;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:img
                                                                             style:self.splitViewController.displayModeButtonItem.style
                                                                            target:self.splitViewController.displayModeButtonItem.target
                                                                            action:self.splitViewController.displayModeButtonItem.action
                                             ];
    self.navigationItem.leftBarButtonItem.accessibilityLabel = menuIsOpen ? kLangHideSidebarAccLabel : kLangShowSidebarAccLabel;;
}

#pragma mark - Custom floor selector support

- (MPFloorSelectorControl*) floorSelector {
    
    return (MPFloorSelectorControl*) self.mapControl.customFloorSelector;
}

- (void) setupCustomFloorSelector {
    
    if ( self.disableFloorSelectorControl == NO ) {
        
        MPFloorSelectorControl*  floorSel = self.floorSelector;
        
        if ( floorSel == nil ) {

            Class   floorSelectorClass = [AppVariantData sharedAppVariantData].customFloorSelectorClass ?: [MPFloorSelectorControl class];
            floorSel = [floorSelectorClass new];
            
            floorSel.backgroundColor = [UIColor whiteColor];
            floorSel.topImageView.backgroundColor = [UIColor whiteColor];
            floorSel.topIcon = [UIImage imageNamed:@"floorSelectorGray"];
            floorSel.translatesAutoresizingMaskIntoConstraints = NO;
            floorSel.disableAutomaticLayoutManagement = YES;
            floorSel.alpha = 0;
            
            [self monitorFloorSelectorChangesForAccessibility:floorSel];
        }
        
        if ( floorSel.superview == nil ) {
            
            [self.view addSubview:floorSel];
            
            [floorSel autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.view withMultiplier:0.5 relation:NSLayoutRelationLessThanOrEqual];
            [floorSel autoSetDimension:ALDimensionWidth toSize:40];
            [floorSel autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:self.myLocationBtn withOffset:-16];
            [floorSel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:8];
        }
        
        self.mapControl.customFloorSelector = floorSel;
    }
}

- (void) monitorFloorSelectorChangesForAccessibility:(MPFloorSelectorControl*)floorSelector {
    
    [self.KVOController observe:floorSelector keyPath:@"nFloors" options:NSKeyValueObservingOptionNew block:^(MapViewController* _Nullable observer, MPFloorSelectorControl* _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
        
        // When nFloors change, the floor-buttons have not yet been added to the buttons array.
        // So post an update for the *next* run of the main queue/thread.
        // This is kind of fragile, and we should make an explicit way for the app code to know when the floor buttons have been properly configured.
        // (Possibly by adding a new, optional, method to the MPFloorSelectorDelegate protocol)
        
        dispatch_async(dispatch_get_main_queue(), ^{
            for ( NSObject* b in observer.floorSelector.buttons ) {
                id  text = [b valueForKeyPath:@"titleLabel.text"] ?: [b valueForKeyPath:@"text"] ?: [b valueForKeyPath:@"title"];
                if ( [text isKindOfClass:[NSString class]] ) {
                    b.accessibilityLabel = [NSString stringWithFormat:kLangSelectFloorNAccLabel, text];
                }
            }
        });
    }];
}

- (void) setShouldShowFloorSelector:(BOOL)shouldShowFloorSelector {

    if ( _shouldShowFloorSelector != shouldShowFloorSelector ) {
        _shouldShowFloorSelector = shouldShowFloorSelector;

            if ( _shouldShowFloorSelector && self.focusedBuilding ) {
            [self showCustomFloorSelector];
        } else {
            [self hideCustomFloorSelector];
        }
    }
}

- (void) hideCustomFloorSelector {

    if ( self.floorSelector.alpha ) {
        [UIView animateWithDuration:0.2 animations:^{
            self.floorSelector.alpha = 0;
        }];
    }
}

- (void) showCustomFloorSelector {

    if ( (self.floorSelector.alpha < 1) && self.shouldShowFloorSelector ) {
        [UIView animateWithDuration:0.2 animations:^{
            self.floorSelector.alpha = 1;
        }];
    }
}


#pragma mark - Positioning & My Location

- (void) locationServicesCheck {
    
    if ( self.locationServicesAlert ) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    UIAlertController* alert = [self alertControllerForLocationServicesState];
    
    if ( alert ) {
        if (!(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) {
            alert.modalPresentationStyle = UIModalPresentationFullScreen;
        }
        
        [self presentViewController:alert animated:YES completion:nil];
        self.locationServicesAlert = alert;
    }
    BOOL locationServicesActive = MapsIndoors.positionProvider.locationServicesActive;
    [self.mapControl showUserPosition: locationServicesActive];
    self.myLocationBtn.trackingButtonState = locationServicesActive ? TrackingButtonState_Enabled : TrackingButtonState_Disabled;
}

- (void) connectPositionProviderToMapControl {
    
    if ( MapsIndoors.positionProvider && (self.didConnectPositionProviderToMapControl == NO) ) {
        self.didConnectPositionProviderToMapControl = YES;

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self locationServicesCheck];
        });

        [self.KVOController observe:MapsIndoors.positionProvider keyPath:@"locationServicesActive" options:NSKeyValueObservingOptionNew block:^(MapViewController* _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
            [observer locationServicesCheck];
        }];

        [self.KVOController observe:MapsIndoors.positionProvider keyPath:@"enableDebugInfo" options:NSKeyValueObservingOptionNew block:^(MapViewController* _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
            [observer updateDebugInfoLabel];
        }];
    }
}

- (void) setupMyLocationButton {
    
    if ( self.myLocationBtn == nil ) {
        
        self.myLocationBtn = [[MyLocationButton alloc] init];
        
        [self.myLocationBtn addTarget:self action:@selector(toggleLocationTracking:) forControlEvents:UIControlEventTouchUpInside];
    }

    if ( self.myLocationBtn.superview == nil ) {
        
        [self.view addSubview: self.myLocationBtn];
        
        UIView* referenceView = _mapView;
        
        NSLayoutYAxisAnchor*    bottomAnchor = referenceView.layoutMarginsGuide.bottomAnchor;
        if (@available(iOS 11.0, *)) {
            bottomAnchor = referenceView.safeAreaLayoutGuide.bottomAnchor;
        }
        [self.myLocationBtn.bottomAnchor constraintEqualToAnchor:bottomAnchor constant:-32 -self.mapView.padding.bottom].active = YES;
        [self.myLocationBtn autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:referenceView withOffset:8];
        [self.myLocationBtn autoSetDimensionsToSize:CGSizeMake(40, 40)];
    }
}

- (void)onPositionUpdate:(MPPositionResult *)positionResult {
    [self onPositionUpdateImpl:positionResult];
    [self refreshMyLocationGraphic];
    [self updateDebugInfoLabel];
}

- (void)onPositionUpdateImpl:(MPPositionResult *)positionResult {

    if ( self.mapRouteTrackingModel.isTracking ) {

        CLLocationCoordinate2D coord = [positionResult.geometry getCoordinate];

        if ( CLLocationCoordinate2DIsValid(coord) && (coord.latitude != 0.0f) ) {
            [self.mapRouteTrackingModel onPositionUpdate:positionResult];
        }
    }

    if ([self.floorSelector class] != [MPFloorSelectorControl class]) {
        if ( [self.floorSelector respondsToSelector:@selector(setUserFloor:)] ) {
            [self.floorSelector performSelector:@selector(setUserFloor:) withObject:[positionResult getFloor]];
        }
    }
}


#pragma mark - Zoom helpers

- (void) zoomToVenue:(MPVenue*)venue {
    [_mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:[venue getBoundingBox] withEdgeInsets:UIEdgeInsetsMake(20, 20, 100, 20)]];
    //Every time a venue is displayed, it becomes the new initial starting point if map is cleared or venue selector is opened
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self->_camera = self->_mapView.camera;
    });
}

- (void) zoomToVenue {
    [self.mapRouteTrackingModel suspendTracking];
    [self zoomToVenue: Global.venue];
}

- (void) zoomToBuilding:(MPBuilding*)building {
    [_mapView animateWithCameraUpdate:[GMSCameraUpdate fitBounds:[building getBuildingBounds] withEdgeInsets:UIEdgeInsetsMake(20, 20, 100, 20)]];   
}

- (void)zoomIn {
    [_mapView animateToZoom:_mapView.camera.zoom+1];
}


#pragma mark - Category data support, MPCategoriesProviderDelegate

- (MPCategoriesProvider *)categoriesProvider {
    
    if ( _categoriesProvider == nil ) {
        _categoriesProvider = [MPCategoriesProvider new];
        _categoriesProvider.delegate = self;
    }
    
    return _categoriesProvider;
}

- (void) onCategoriesReady:(NSArray*)categories {

    // Transform categories array into dictionary:
    NSArray<NSString*>* keys = [[categories valueForKeyPath:@"key"] valueForKey:@"uppercaseString"];
    NSArray<NSString*>* values = [categories valueForKeyPath:@"value"];
    self.categoriesMap = [NSDictionary dictionaryWithObjects:values forKeys:keys];
}

- (NSString*) categoryNameFromKey:(NSString*)categoryKey {
    
    return self.categoriesMap[[categoryKey uppercaseString]] ?: categoryKey;
}

- (NSArray<NSString*>*) categoryNamesFromKeys:(NSArray<NSString*>*)categoryKeys {
    
    NSMutableArray<NSString*>*  names = [NSMutableArray array];
    
    for ( NSString* key in categoryKeys ) {
        [names addObject:[self categoryNameFromKey:key]];
    }
    
    return [names copy];
}

- (void) stopTrackingUserLocation {
    self.mapRouteTrackingModel.trackingMode = MPMapTrackingMode_DoNotTrack;

    self.myLocationBtn.trackingButtonState = TrackingButtonState_Enabled;

    _directionsRenderer.fitBounds = YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {

    if ( [kZoomObservePath isEqualToString: keyPath] ) {

        double oldZoom = [[change objectForKey:NSKeyValueChangeOldKey] doubleValue];
        double newZoom = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];

        if ( (oldZoom > 0) && (oldZoom < newZoom) && self.userGestureInProgress ) {     // Zoom changed because of user gesture; remove zoom hint.
            [_mapView removeObserver:self forKeyPath:kZoomObservePath];
            [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:kHasAppliedZoomHint];
            [UIView animateWithDuration:0.5 animations:^{
                self->_zoomHintBtn.alpha = 0;
            } completion:^(BOOL finished) {
                [self->_zoomHintBtn removeFromSuperview];
            }];
        }

    } else if ( [kViewingAngleObservePath isEqualToString:keyPath] ) {

        // Limit max viewingAngle when in turn by turn mode because of Google Maps using up all memory when:
        //      camera target has been offset to the bottom of the screen
        //      AND
        //      the viewing angle is too large (presumably showing too much in th edistance).
        //
        if ( self.mapRouteTrackingModel.isTracking && self.mapRouteTrackingModel.turnByTurnMode ) {
            GMSCameraPosition*   c = _mapView.camera;
            if ( c.viewingAngle > kMaxViewingAngleForTurnByTurn ) {
                _mapView.camera = [GMSCameraPosition cameraWithTarget:c.target zoom:c.zoom bearing:c.bearing viewingAngle:kMaxViewingAngleForTurnByTurn];
            }
        }
    }
}


#pragma mark - Toast message support

- (void) showToastMessage:(NSString*)msg buttonTitle:(NSString*)buttonTitle buttonClickHandler:(MPToastViewButtonClickBlockType)buttonClickHandler {
    
    MPToastView*    toast = self.toastView;

    if ( toast == nil ) {
        self.toastView = toast = [MPToastView newWithMessage:msg buttonTitle:buttonTitle buttonClickHandler:buttonClickHandler];
        [self.stackView insertArrangedSubview:toast atIndex:MIN(StackLayoutIndex_Toast,self.stackView.arrangedSubviews.count)];
        
        CGFloat     safeAreaExtraHeight = 0;
        if (@available(iOS 11.0, *)) {
            safeAreaExtraHeight = self.view.safeAreaInsets.bottom;
        }
        
        [self.toastView autoSetDimension:ALDimensionHeight toSize:44 +safeAreaExtraHeight relation:NSLayoutRelationGreaterThanOrEqual];
    
    } else {
        toast.message = msg;
        toast.buttonTitle = buttonTitle;
        toast.buttonClickHandler = buttonClickHandler;
        
        if ( self.toastView.hidden ) {
            [UIView animateWithDuration:.3 animations:^{
                self.toastView.hidden = NO;
                [self.stackView layoutIfNeeded];
            }];
        }
    }
}

- (void) hideToastMessage {
    
    if ( self.toastView ) {

        if ( self.toastView.hidden == NO ) {
            [UIView animateWithDuration:.3 animations:^{
                self.toastView.hidden = YES;
                [self.stackView layoutIfNeeded];
            }];
        }
    }
}


#pragma mark -

- (CGFloat) heaightForDirectionsPanel {
    
    CGFloat h = (self.horizontalRoutingController.verticalMode) ? kDirectionsContainerHeightVerticalMode : kDirectionsContainerHeight;

    h += self.bottomLayoutGuide.length;
    
    return h;
}


#pragma mark - Custom compass support

- (void) setupCustomMapCompass {
    
    if ( self.customCompass == nil ) {
        
        _mapView.settings.compassButton = NO;
        
        CGFloat     compassTop = 14;
        if (@available(iOS 11.0, *)) {
            compassTop += self.view.safeAreaInsets.top;
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            compassTop += self.topLayoutGuide.length;
#pragma clang diagnostic pop
        }

        UIImageView*    compassView = [UIImageView new];
        compassView.image = [UIImage imageNamed:@"map_compass"];
        compassView.userInteractionEnabled = YES;
        compassView.alpha = 0;
        [self.view addSubview:compassView];
        [compassView autoSetDimensionsToSize:CGSizeMake(32, 32)];
        [compassView autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:_mapView withOffset:compassTop];
        [compassView autoPinEdge:ALEdgeRight toEdge:ALEdgeRight ofView:_mapView withOffset:-14];
        
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onCompassTapped:)];
        [compassView addGestureRecognizer:tap];

        self.customCompass = compassView;
        
        compassView.layer.shadowColor = [UIColor blackColor].CGColor;
        compassView.layer.shadowRadius = 2;
        compassView.layer.shadowOpacity = 0.3;
        compassView.layer.shadowOffset = CGSizeMake(0,0);
    }
}

- (void) onCompassTapped:(UITapGestureRecognizer*)tapGesture {

    [_mapView animateToBearing: 0 ];

    if ( self.mapRouteTrackingModel.trackingMode == MPMapTrackingMode_FollowWithHeading ) {
        self.mapRouteTrackingModel.trackingMode = MPMapTrackingMode_Follow;
    }

    [Tracker trackEvent:@"Map_Compass_Clicked" parameters:nil];
}

- (void) setCustomCompassBearing:(CLLocationDegrees)customCompassBearing {

    if ( fabs(customCompassBearing) < 1 ) {     // Snap to north
        customCompassBearing = 0;
    }

    CLLocationDegrees   delta = fabs( _customCompassBearing - customCompassBearing );
    
    if ( delta >= 1 ) {
        _customCompassBearing = customCompassBearing;
        [self updateCompass];
    }
}

- (void) updateCompass {
    
    self.customCompass.transform = CGAffineTransformRotate( CGAffineTransformIdentity, - self.customCompassBearing * (M_PI / 180) );
    
    CGFloat desiredCompassAlpha = (self.customCompassBearing != 0) || _directionsRenderer.isRenderingRoute ? 1 : 0;
    if ( self.customCompass.alpha != desiredCompassAlpha ) {
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayedCompassHide) object:nil];
        
        if ( desiredCompassAlpha == 0 ) {
            
            [self performSelector:@selector(delayedCompassHide) withObject:nil afterDelay:1.4];     // 1.4 secs is the same delay as GMSMapView's compass disappears with.
            
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                self.customCompass.alpha = desiredCompassAlpha;
            }];
        }
    }
}

- (void) delayedCompassHide {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.customCompass.alpha = 0;
    }];
}


//- (CGSize) getImageSizeForLocationClusterWithCount:(NSUInteger)count clusterId:(NSString* _Nonnull)clusterId {
//
//    return CGSizeMake(44, 44);
//}
//
//- (BOOL) getImageForLocationCluster:(NSArray<MPLocation *> *)locationCluster imageSize:(CGSize)imageSize clusterId:(NSString *)clusterId completion:(void (^ _Nonnull)(UIImage * _Nullable))completion {
//
//    NSString*   imageName = (locationCluster.count > 9) ? @"group9plus" : [NSString stringWithFormat:@"group%@", @(locationCluster.count)];
//
//#if 0   // Async image delivery
//    dispatch_async( dispatch_get_main_queue(), ^{
//        completion( [UIImage imageNamed:imageName] );
//    });
//#else   // Sync image delivery: Call completion before returning from this method
//    completion( [UIImage imageNamed:imageName] );
//#endif
//
//    return YES;
//}


#pragma mark - Map tracking, MPMapRouteTrackingModelDelegate

- (MPMapRouteTrackingModel*) mapRouteTrackingModel {

    if ( (_mapRouteTrackingModel == nil) && MapsIndoors.positionProvider ) {
        _mapRouteTrackingModel = [MPMapRouteTrackingModel newWithMap:_mapView delegate:self];
        _mapRouteTrackingModel.positionAgeLimit = 30;
        if ( MapsIndoors.positionProvider.latestPositionResult ) {
            [_mapRouteTrackingModel onPositionUpdate: MapsIndoors.positionProvider.latestPositionResult];
        }
        if ( [AppVariantData sharedAppVariantData].mapShouldTrackUserLocationOnAppLaunch ) {
            _mapRouteTrackingModel.trackingMode = MPMapTrackingMode_Follow;
        }
    }
    return _mapRouteTrackingModel;
}

- (void) mapRouteTrackingModel:(MPMapRouteTrackingModel *)tracker didSwitchFloor:(NSNumber *)floor {

    if ( tracker.isTracking ) {
        self.mapControl.currentFloor = floor;
        [self.mapControl showUserPosition:YES];
    }
}

- (void) mapRouteTrackingModel:(MPMapRouteTrackingModel *)tracker didDetermineMapCenter:(CLLocationCoordinate2D)mapCenter zoom:(double)zoom bearing:(double)bearing viewingAngle:(double)viewingAngle floor:(NSNumber *)floor {

    if ( tracker.isTracking ) {

        if ( [floor isEqualToNumber:self.mapControl.currentFloor] == NO ) {
            self.mapControl.currentFloor = floor;
        }

        [_mapView animateToCameraPosition:[GMSCameraPosition cameraWithTarget:mapCenter zoom:zoom bearing:bearing viewingAngle:viewingAngle]];
    }
}

- (void) mapRouteTrackingModel:(MPMapRouteTrackingModel *)tracker didMoveToRouteLegIndex:(NSInteger)legIndex stepIndex:(NSInteger)stepIndex onRoute:(MPRoute *)route {

    if (_directionsRenderer.isRenderingRoute) {

        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLocationTrackingOccurred object:nil userInfo:@{kLegIndex:@(legIndex), kStepIndex:@(stepIndex)}];

        if ( _directionsRenderer.routeLegIndex != legIndex ) {
            _directionsRenderer.routeLegIndex = legIndex;
            //TODO: Make step rendering work if relevant
            //_directionsRenderer.routeStepIndex = stepIndex;
        }
    }
}

- (void) mapRouteTrackingModel:(MPMapRouteTrackingModel *)tracker didChangeTrackingState:(MPMapTrackingState)state userGesture:(BOOL)userGesture {

    [self updateMapTrackingUI:userGesture];
}

#pragma mark - MPLiveDataManagerDelegate

- (void)didReceiveLiveDataInfo:(MPLiveDataInfo *)info {
    
    self.activeLiveDataDomains = info.activeDomainTypes;
    
    [self enableLiveData];
    
}

#pragma mark - Return to "venue"

- (void) centerMapOnPosition:(CLLocationCoordinate2D)centerCoordinate {

    GMSMutableCameraPosition*   newCamera = [[GMSCameraPosition cameraWithTarget:centerCoordinate zoom:self.mapView.camera.zoom] mutableCopy];
    newCamera.viewingAngle = self.mapView.camera.viewingAngle;
    newCamera.bearing = self.mapView.camera.bearing;

    [self.mapView animateToCameraPosition: newCamera ];
}

- (void) returnToVenue {

    [self.mapRouteTrackingModel suspendTracking];

    MPVenue*    targetVenue = Global.venue ?: self.autoSelectedInitialVenue;
    if ( targetVenue ) {
        [self zoomToVenue: targetVenue];
    }
}

- (void) updateReturnToVenueBtnText {

    NSString*   targetName;

    if ( Global.venue ) {
        targetName = Global.venue.name;
    } else if ( self.autoSelectedInitialVenue ) {
        targetName = self.autoSelectedInitialVenue.name;
    }

    if ( targetName.length ) {
        NSString*   s = [NSString stringWithFormat:@"%@ %@", kLangReturnTo, targetName];
        [_returnToVenueOrLocationBtn setTitle:s.uppercaseString forState:UIControlStateNormal];
    }
}

- (BOOL) isVisibleRegionEmpty {

    GMSVisibleRegion        visibleRegion = self.mapView.projection.visibleRegion;

    CLLocationDistance      d1 = GMSGeometryDistance(visibleRegion.nearLeft,visibleRegion.nearRight);
    CLLocationDistance      d2 = GMSGeometryDistance(visibleRegion.nearLeft,visibleRegion.farLeft);

    return (d1 + d2) < 0.001;
}

- (BOOL) isCoordinateVisibleOnMap:(CLLocationCoordinate2D)coo {

    GMSVisibleRegion        visibleRegion = self.mapView.projection.visibleRegion;
    GMSMutablePath*         displayedArea = [GMSMutablePath new];

    [displayedArea addCoordinate:visibleRegion.nearLeft];
    [displayedArea addCoordinate:visibleRegion.farLeft];
    [displayedArea addCoordinate:visibleRegion.farRight];
    [displayedArea addCoordinate:visibleRegion.nearRight];

    return GMSGeometryContainsLocation( coo, displayedArea, YES );
}

- (void) updateReturnToVenueBtnVisibility {

    [self updateReturnToVenueBtnText];

    // Show "Return" button if the map is not showing any buildings (i.e. not showing anything from the venue):
    MPLocation* building = self.focusedBuilding;
    MPBuilding* mpBuilding = [[BuildingInfoCache sharedInstance] buildingFromName:building.name];
    CGFloat zoomToVenueBtnAlpha = 1;

    if ( [self isVisibleRegionEmpty] ) {
        zoomToVenueBtnAlpha = 0;

    } else if ( self.mapControl.searchResult ) {
        zoomToVenueBtnAlpha = 0;

    } else if ( _directionsRenderer.isRenderingRoute ) {
        zoomToVenueBtnAlpha = 0;

    } else if ( building ) {

        if ( (Global.venue.venueId && [mpBuilding.venueId isEqualToString:Global.venue.venueId]) ||
             (self.autoSelectedInitialVenue && [mpBuilding.venueId isEqualToString:self.autoSelectedInitialVenue.venueId]) ) {
            zoomToVenueBtnAlpha = 0;
        }
    }

    if ( zoomToVenueBtnAlpha && [self isCoordinateVisibleOnMap:Global.venue.anchor.getCoordinate] ) {
        zoomToVenueBtnAlpha = 0;
    }
    if ( [_returnToVenueOrLocationBtn titleForState:UIControlStateNormal].length == 0 ) {
        zoomToVenueBtnAlpha = 0;
    }

    if ( _returnToVenueOrLocationBtn.alpha != zoomToVenueBtnAlpha ) {
        if ( zoomToVenueBtnAlpha > 0 ) {
            [_mapView addSubview: _returnToVenueOrLocationBtn];
            [UIView animateWithDuration:0.5 animations:^{
                self->_returnToVenueOrLocationBtn.alpha = zoomToVenueBtnAlpha;
            }];
        } else {
            [UIView animateWithDuration:0.5 animations:^{
                self->_returnToVenueOrLocationBtn.alpha = zoomToVenueBtnAlpha;
            } completion:^(BOOL finished) {
                [self->_returnToVenueOrLocationBtn removeFromSuperview];
            }];
        }
    }
}


#pragma mark - Debug info

- (void) updateDebugInfoLabel {

    id<AppPositionProvider>     pp;

    if ( [MapsIndoors.positionProvider conformsToProtocol:@protocol(AppPositionProvider)] ) {
        pp = (id<AppPositionProvider>)MapsIndoors.positionProvider;
    }

    NSString*   s = pp.debugInfo;

    if ( (self.debugInfoLabel == nil) && s.length ) {
        UILabel*    label = [UILabel new];
        self.debugInfoLabel = label;
        self.debugInfoLabel.opaque = NO;
        self.debugInfoLabel.numberOfLines = 0;
        self.debugInfoLabel.textColor = UIColor.yellowColor;
        self.debugInfoLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        self.debugInfoLabel.translatesAutoresizingMaskIntoConstraints = NO;

        [self.view addSubview:self.debugInfoLabel];
        [self.debugInfoLabel.rightAnchor constraintEqualToAnchor:self.mapView.rightAnchor constant:-8].active = YES;
        [self.debugInfoLabel.bottomAnchor constraintEqualToAnchor:self.mapView.bottomAnchor constant:-8].active = YES;

//        if (@available(iOS 11.0, *)) {
            [self.debugInfoLabel.widthAnchor constraintLessThanOrEqualToAnchor:self.view.widthAnchor multiplier:0.7].active = YES;
//        } else {
//            // ...can't be bothered to make fallback on earlier versions
//        }
    }

    if ( self.debugInfoLabel ) {
        NSArray<NSString*>* lines = [s componentsSeparatedByString:@"\n"];
        s = [NSString stringWithFormat:@"\n  %@  \n", [lines componentsJoinedByString:@"  \n  "]];
        self.debugInfoLabel.text = s ?: @"Debug info not available";
    }

    self.debugInfoLabel.hidden = pp.enableDebugInfo == NO;
}


@end
