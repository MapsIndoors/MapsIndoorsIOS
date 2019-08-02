//
//  DirectionsController.m
//  MIAIOS
//
//  Created by Daniel Nielsen on 13/08/15.
//  Copyright (c) 2015-2018 MapsPeople A/S. All rights reserved.
//

#import "DirectionsController.h"
#import <MapsIndoors/MapsIndoors.h>
#import "UIColor+AppColor.h"
#import "RoutingData.h"
#import "Global.h"
#import "UIButton+AppButton.h"
#import "UINavigationController+TransparentNavigationController.h"
#import "PlacePickerSearchController.h"
#import "UIViewController+Custom.h"
#import "LocalizationSystem.h"
#import "LocalizedStrings.h"
#import "SectionModel.h"
#import "UIButton+HitEdges.h"
#import "MPDirectionsView.h"
#import "NSString+TRAVEL_MODE.h"
#import "DottedLine.h"
#import "Tracker.h"

@import MaterialControls;
@import VCMaterialDesignIcons;
@import PureLayout;
#import "UIViewController+LocationServicesAlert.h"
#import "TransitSourcesTableViewController.h"
#import "LocalizedStrings.h"
#import "NSObject+MPNetworkReachability.h"
#import "MPReverseGeocodingService.h"
#import "MPRoute+SectionModel.h"
#import "MPAccessibilityHelper.h"
#import "AppVariantData.h"
#import "NSObject+ContentSizeChange.h"
#import "AppFonts.h"
#import "TCFKA_MDSnackbar.h"
#import "MPRouteSettingsViewController.h"
#import "MPUserRoleManager.h"


@interface DirectionsController () < MPDirectionsViewDelegate >

@property (weak, nonatomic) IBOutlet MPDirectionsView*  directionsView;

@property (nonatomic, strong) NSArray<SectionModel*>*   sectionModelArray;

@property (nonatomic, strong) RoutingData*              routing;
@property (nonatomic, strong) MDButton*                 nextBtn;
@property (nonatomic, strong) MDButton*                 prevBtn;
@property (nonatomic, strong) MDButton*                 showBtn;

@property (nonatomic, strong) UIBarButtonItem*          car;
@property (nonatomic, strong) UIBarButtonItem*          bike;
@property (nonatomic, strong) UIBarButtonItem*          train;
@property (nonatomic, strong) UIBarButtonItem*          walk;

@property (nonatomic, strong) UIBarButtonItem*          routeSettings;
@property (nonatomic) BOOL                              showRouteSettings;


@property (nonatomic, strong) NSArray*                  avoids;

@property (nonatomic, strong) MPLocation*               myLocation;

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView*  spinner;
@property (nonatomic) UIInterfaceOrientation            currentOrientation;
@property (nonatomic, strong) MPLocation*               origin;
@property (nonatomic, strong) MPLocation*               destination;

@property (nonatomic, strong) CLLocationManager*        xAppLocationManager;

@property (nonatomic) BOOL                              isFirstLoading;
@property (nonatomic) BOOL                              disableAppearanceSetup;

@property (nonatomic, weak) UIAlertController*          locationServicesAlert;

@property (nonatomic, strong) NSArray<MPTransitAgency*>*    transitSources;

@property (weak, nonatomic) IBOutlet UIImageView*           noRouteImageView;
@property (weak, nonatomic) IBOutlet UILabel*               noRouteMessageLabel;

@property (weak, nonatomic) IBOutlet UIStackView*           directionsHeaderView;

// Reachability warning
@property (weak, nonatomic) IBOutlet UIView*                    reachabilityWarningView;
@property (weak, nonatomic) IBOutlet UIImageView*               reachabilityWarningImageView;
@property (weak, nonatomic) IBOutlet UILabel*                   reachabilityWarningLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView*   reachabilitySpinner;

@end


@implementation DirectionsController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _routing = Global.routingData;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRouteRequest) name:@"RoutingRequestStarted" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRouteResultReady:) name:@"RoutingDataReady" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(next:) name:@"ShowNextRouteLegInList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(prev:) name:@"ShowPreviousRouteLegInList" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(openDirectionsOnMap) name:@"openDirectionsOnMap" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:@"UIDeviceOrientationDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMapData:) name:kNotificationLocationServicesActivated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveToCurrentLeg:) name:kNotificationShowSelectedLegInList object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationTrackingOccured:) name:kNotificationLocationTrackingOccurred object:nil];
    
    [self.directionsHeaderView removeFromSuperview];

    self.isFirstLoading = true;
    self.sectionModelArray = @[];
    
    self.xAppLocationManager = [CLLocationManager new];
    self.xAppLocationManager.delegate = self;
    
    [self.destinationButton addTarget:self action:@selector(openDestinationSearch) forControlEvents:UIControlEventTouchDown];
    [self.originButton addTarget:self action:@selector(openOriginSearch) forControlEvents:UIControlEventTouchDown];
    
    self.originButton.layer.cornerRadius = 6.0f;
    self.destinationButton.layer.cornerRadius = 6.0f;
    
    self.originButton.backgroundColor = [UIColor appDarkPrimaryColor];
    self.destinationButton.backgroundColor = [UIColor appDarkPrimaryColor];
    
    self.originButton.contentEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    self.destinationButton.contentEdgeInsets = UIEdgeInsetsMake(6, 6, 6, 6);
    self.originButton.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -50, -10, -10);
    self.destinationButton.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -50, -10, -10);

    self.line.thickness = 4.0f;
    self.line.color = [UIColor appLightPrimaryColor];
    self.line.dashedGap = 4.0f;
    self.line.dashedLength = 4.0f;
    
    self.locationServicesBtn.layer.borderWidth = 1.0;
    self.locationServicesBtn.layer.borderColor = [UIColor appSecondaryTextColor].CGColor;
    self.locationServicesBtn.layer.opacity = 0.30;
    self.locationServicesBtn.layer.cornerRadius = 2.0;
    self.locationServicesBtn.layer.shadowRadius = 1.0;
    self.locationServicesBtn.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    self.locationServicesBtn.layer.shadowColor = [UIColor blackColor].CGColor;
    self.locationServicesBtn.layer.shadowOpacity = 1.0;
    
    UIImage* dirImage = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_swap_vertical fontSize:28.0f].image;
    [self.switchDirIconButton setImage:dirImage forState:UIControlStateNormal];
    [self.switchDirIconButton addTarget:self action:@selector(switchDir) forControlEvents:UIControlEventTouchUpInside];
    self.switchDirIconButton.tintColor = [UIColor whiteColor];
    
    UIImage* carImg = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_car fontSize:22.0f].image;
    _car = [[UIBarButtonItem alloc] initWithImage:carImg style:UIBarButtonItemStylePlain target:self action:@selector(transitMode:)];
    _car.accessibilityHint = kLangByCar;
    
    UIImage* bikeImg = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_bike fontSize:22.0f].image;
    _bike = [[UIBarButtonItem alloc] initWithImage:bikeImg style:UIBarButtonItemStylePlain target:self action:@selector(transitMode:)];
    _bike.accessibilityHint = kLangByCycling;
    
    UIImage* trainImg = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_bus fontSize:22.0f].image;
    _train = [[UIBarButtonItem alloc] initWithImage:trainImg style:UIBarButtonItemStylePlain target:self action:@selector(transitMode:)];
    _train.accessibilityHint = kLangByTransit;
    
    UIImage* walkImg = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_walk fontSize:22.0f].image;
    _walk = [[UIBarButtonItem alloc] initWithImage:walkImg style:UIBarButtonItemStylePlain target:self action:@selector(transitMode:)];
    _walk.accessibilityHint = kLangByWalk;

    UIImage* routeSettingsImg = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_tune fontSize:22.0f].image;
    self.routeSettings = [[UIBarButtonItem alloc] initWithImage:routeSettingsImg style:UIBarButtonItemStylePlain target:self action:@selector(onRouteSettingsTapped:)];
    self.routeSettings.accessibilityHint = NSLocalizedString(@"Route Settings", );

    self.showRouteSettings = Global.userRoleManager.availableUserRoles.count > 0;
#if BUILDING_SDK_APP
    self.showRouteSettings = YES;
#endif

    if ( self.showRouteSettings ) {
        self.navigationItem.rightBarButtonItems = @[self.routeSettings, _car, _train, _bike, _walk];
    } else {
        self.navigationItem.rightBarButtonItems = @[_car, _train, _bike, _walk];
    }

    _walk.tintColor = [UIColor colorWithWhite: 1.0f alpha:0.5f];
    _train.tintColor = [UIColor colorWithWhite: 1.0f alpha:0.5f];
    _car.tintColor = [UIColor colorWithWhite: 1.0f alpha:0.5f];
    _bike.tintColor = [UIColor colorWithWhite: 1.0f alpha:0.5f];
    
    [self.avoidStairsSwitch addTarget:self action:@selector(avoidStairs) forControlEvents:UIControlEventValueChanged];
    self.avoidStairsSwitch.thumbOn = [UIColor whiteColor];
    self.avoidStairsSwitch.trackOn = [UIColor appLightPrimaryColor];
    self.avoidStairsSwitch.thumbOff = [UIColor whiteColor];
    self.avoidStairsSwitch.trackOff = [UIColor appDarkPrimaryColor];
    self.avoidStairsSwitch.on = Global.avoidStairs;
    self.avoidStairsSwitch.accessibilityLabel = kLangAvoidStairs;
    self.avoidStairsSwitch.accessibilityHint = Global.avoidStairs ? kLangAvoidStairsOnAccHint : kLangAvoidStairsOffAccHint;
    self.avoidStairsSwitch.isAccessibilityElement = YES;
    self.avoidStairsSwitch.accessibilityTraits = UIAccessibilityTraitButton;
    
    UITapGestureRecognizer* helperForTheLittleMDSwitchThatCouldntDetectTapsProperly = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avoidStairsWasTapped:)];
    [self.avoidStairsSwitch addGestureRecognizer:helperForTheLittleMDSwitchThatCouldntDetectTapsProperly];
    
    self.directionsForm.backgroundColor = [UIColor appPrimaryColor];
    self.avoidStairsLabel.text = kLangAvoidStairs;
    
    self.directionsView.delegate = self;
    self.directionsView.verticalLayout = YES;
    self.directionsView.verticalLegHeight = 108;
    self.directionsView.shouldHighlightFocusedRouteSegment = YES;

    // Move the directionsForm from self.view to be managed as a "header-view" of the DirectionsView:
    CGRect r = self.directionsHeaderView.frame;
    r.origin.y = 0;
    self.directionsHeaderView.translatesAutoresizingMaskIntoConstraints = YES;
    self.directionsHeaderView.frame = r;
    
    self.directionsView.headerViewInVerticalMode = self.directionsHeaderView;
    self.directionsView.headerAccessibilityElementsInVerticalMode = @[ self.originButton
                                                                     , self.destinationButton
                                                                     , self.switchDirIconButton
                                                                     , self.avoidStairsSwitch
                                                                     , self.durationEstimate
                                                                     ];
    
    BOOL locationServicesActive = [MapsIndoors.positionProvider isRunning];
#if defined(MI_SDK_VERSION_MAJOR) && (MI_SDK_VERSION_MAJOR >= 2)
    locationServicesActive = MapsIndoors.positionProvider.locationServicesActive;
#endif
    self.offlineMsg.hidden = locationServicesActive;
    self.offlineMsgDetail.hidden = locationServicesActive;
    self.lightningImgView.hidden = locationServicesActive;
    self.locationServicesBtn.hidden = locationServicesActive;
    
    self.noRouteMessageLabel.text = kLangNoRouteFound;
    
    __weak typeof(self)weakSelf = self;
    self.reachabilityWarningView.hidden = YES;
    [self configureReachabilityWarning: self.mp_isNetworkReachable ];
    [self mp_onReachabilityChange:^(BOOL isNetworkReachable) {
        [weakSelf configureReachabilityWarning:isNetworkReachable];
        
        if ( isNetworkReachable && (weakSelf.currentRoute == nil) ) {
            [weakSelf updateRouting];
        }
    }];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"EnableHorizontalDirections" object:nil];

    self.originButton.accessibilityHint      = kLangSelectRouteOriginAccHint;
    self.destinationButton.accessibilityHint = kLangSelectRouteDestinationAccHint;
    self.switchDirIconButton.accessibilityHint = kLangSwapRouteStartAndDestinationAccHint;

    self.originButton.titleLabel.font = [AppFonts sharedInstance].buttonFont;
    self.destinationButton.titleLabel.font = [AppFonts sharedInstance].buttonFont;
    self.avoidStairsLabel.font = [AppFonts sharedInstance].buttonFont;
    self.durationEstimate.font = [AppFonts sharedInstance].directionsFont;
    self.offlineMsg.font = [AppFonts sharedInstance].directionsFontSmall;
    self.offlineMsgDetail.font = [AppFonts sharedInstance].directionsFontSmall;
    self.noRouteMessageLabel.font = [AppFonts sharedInstance].directionsFontSmall;
    [self configureLocationServiceOffMessage];
    self.reachabilityWarningLabel.font = [[AppFonts sharedInstance] scaledFontForSize:11];

    [self mp_onContentSizeChange:^(DynamicTextSize dynamicTextSize) {

        __strong __typeof(weakSelf)strongSelf = weakSelf;

        strongSelf.originButton.titleLabel.font = [AppFonts sharedInstance].buttonFont;
        strongSelf.destinationButton.titleLabel.font = [AppFonts sharedInstance].buttonFont;
        strongSelf.avoidStairsLabel.font = [AppFonts sharedInstance].buttonFont;
        strongSelf.durationEstimate.font = [AppFonts sharedInstance].directionsFont;
        strongSelf.offlineMsg.font = [AppFonts sharedInstance].directionsFontSmall;
        strongSelf.offlineMsgDetail.font = [AppFonts sharedInstance].directionsFontSmall;
        strongSelf.noRouteMessageLabel.font = [AppFonts sharedInstance].directionsFontSmall;
        [strongSelf configureLocationServiceOffMessage];
        strongSelf.reachabilityWarningLabel.font = [[AppFonts sharedInstance] scaledFontForSize:11];
        [strongSelf.directionsView loadRoute:nil withModels:nil routingData:strongSelf->_routing];
        [strongSelf.directionsView onDynamicContentSizeChanged];
        [strongSelf.directionsView loadRoute:strongSelf.currentRoute withModels:strongSelf.sectionModelArray routingData:strongSelf->_routing];
    }];
}

- (void) configureLocationServiceOffMessage {

    self.offlineMsgDetail.text = ([AppFonts sharedInstance].configuredTextSize < DynamicTextSize_XL) ? kLangTurOnLocationInDirections : kLangTurOnLocationInDirectionsAbbr;
}

- (void) avoidStairsWasTapped:(UITapGestureRecognizer*)tapGesture {
    self.avoidStairsSwitch.on = !self.avoidStairsSwitch.on;
    Global.avoidStairs = self.avoidStairsSwitch.on;
    self.avoidStairsSwitch.accessibilityHint = Global.avoidStairs ? kLangAvoidStairsOnAccHint : kLangAvoidStairsOffAccHint;
}

- (void) onRouteRequest {
    _showBtn.hidden = YES;
    self.currentRoute = nil;
    [self.spinner startAnimating];
    [self.reachabilitySpinner startAnimating];
}

- (void) transitMode:(id)sender {
    
    if (sender) {
        UIBarButtonItem* newSender = sender;
        _walk.tintColor = [UIColor colorWithWhite: 1.0f alpha:0.5f];
        _train.tintColor = [UIColor colorWithWhite: 1.0f alpha:0.5f];
        _car.tintColor = [UIColor colorWithWhite: 1.0f alpha:0.5f];
        _bike.tintColor = [UIColor colorWithWhite: 1.0f alpha:0.5f];
        
        newSender.tintColor = [UIColor whiteColor];
        
        if ([newSender isEqual:_car]) _routing.travelMode = @"driving";
        if ([newSender isEqual:_train]) _routing.travelMode = @"transit";
        if ([newSender isEqual:_bike]) _routing.travelMode = @"bicycling";
        if ([newSender isEqual:_walk]) _routing.travelMode = @"walking";
        
        Global.travelMode = _routing.travelMode;
        
        [self updateRouting];
        
        [Tracker trackEvent:@"Directions_Travel_Mode_Selected" parameters:@{ @"Travel_Mode" : [_routing.travelMode uppercaseString]} ];
    }
}

- (void) avoidStairs {
    
    if (self.avoidStairsSwitch.on) {
        _avoids = @[@"stairs"];
    } else {
        _avoids = nil;
    }
    [self updateRouting];
    
    if ( self.view.superview ) {
        [Tracker trackEvent:@"Directions_Avoid_Stairs_Clicked" parameters:@{ @"Avoid_Stairs" : self.avoidStairsSwitch.on ? @"true" : @"false" }];
    }
}

- (void) switchDir {
    MPLocation* tempDest = self.destination;
    
    self.destination = self.origin;
    self.origin = tempDest;
    
    [self updateRouting];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [Tracker trackScreen:@"Directions"];
    
    [self presentCustomBackButton];
    
    [self.navigationController resetNavigationBar];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.directionsHeaderView.backgroundColor = [UIColor yellowColor];
    [self setupWhenAppeared];

    if ( self.currentRoute ) {
        [[MPAccessibilityHelper sharedInstance] setAccessibilityFocus:self.durationEstimate];
    } else {
        [[MPAccessibilityHelper sharedInstance] setAccessibilityFocus:self.originButton];
    }
}

- (void) setupWhenAppeared {

    if ( self.disableAppearanceSetup == YES ) {
        self.disableAppearanceSetup = NO;

    } else {
        
        
        self.myLocation = [[MPLocation alloc] initWithPoint:MapsIndoors.positionProvider.latestPositionResult.geometry andName:kLangMyPosition];
        
        self.destination = _routing.destination;
        
        //Using my position (guessing a room)
        BOOL    shouldPreloadOrigin = [AppVariantData sharedAppVariantData].shouldPreloadRouteOriginWithCurrentLocation;
        if ( shouldPreloadOrigin && (self.origin == nil) && (MapsIndoors.positionProvider.latestPositionResult.geometry != nil) ) {
            
            self.origin = self.myLocation;       // Un-comment to auto-select users location as starting point for route calc.
           
            MPLocationQuery* query = [[MPLocationQuery alloc] init];
            query.near = MapsIndoors.positionProvider.latestPositionResult.geometry;
            query.max = 1;
            query.floor = 0;
            query.radius = [NSNumber numberWithInt:15];
            
            [MapsIndoors.locationsProvider getLocationsUsingQuery:query completionHandler:^(MPLocationDataset *locationData, NSError *error) {
                
                if (locationData != nil && locationData.list.count == 1) {
                    self.origin = [locationData.list.firstObject copy];
                    //TODO set display rule on mapcontrol instead
                    //self.origin.displayRule.icon = [UIImage imageNamed:@"Mylocation"];
                } else {
                    //TODO set description with builder instead
                    //self.origin.descr = nil;

                    [[MPReverseGeocodingService sharedGeoCoder] reverseGeocodeLocation:self.origin completionHandler:^(GMSReverseGeocodeResponse * _Nullable result, NSError * _Nullable error) {
                        
                        if ( self.origin.mp_firstReverseGeocodedAddress.length ) {
                            //TODO set description with builder instead
                            //self.origin.descr = self.origin.mp_firstReverseGeocodedAddress;
                            
                            [self.directionsView routeUpdated:self.currentRoute];
                            [self updateOriginDestinationButtonTitles];
                        }
                    }];
                }
                
                if (self.isFirstLoading) {
                    //Hide offline msg label and details
                    self.offlineMsg.hidden = YES;
                    self.offlineMsgDetail.hidden = YES;
                    self.lightningImgView.hidden = YES;
                    self.locationServicesBtn.hidden = YES;
                    
                    self.isFirstLoading = false;
                }

                [self updateRouting];
                
                if (locationData != nil && locationData.list.count == 1) {
                    [self.originButton setTitle:[NSString stringWithFormat: kLangEstimatedPosNearVar, self.origin.name] forState:UIControlStateNormal];
                }
            }];
            
        } else {
            
            if (self.isFirstLoading) {
                //TODO set type with builder instead
                //self.origin.type = @"google-place";
                self.isFirstLoading = false;
            }
            
            if ( self.currentRoute == nil ) {
                [self updateRouting];
            }
        }
        
        if ( self.currentRoute == nil ) {
            
            if ( self.mp_isNetworkReachable == NO ) {
                
                NSLog(@"WIFI is not reachable");
                [self.lightningImgView setImage:[UIImage imageNamed:@"iosOfflinex36.png"]];
                
            } else {
                
                BOOL locationServicesActive = [MapsIndoors.positionProvider isRunning];
#if defined(MI_SDK_VERSION_MAJOR) && (MI_SDK_VERSION_MAJOR >= 2)
                locationServicesActive = MapsIndoors.positionProvider.locationServicesActive;
#endif
                self.offlineMsg.hidden = locationServicesActive;
                self.offlineMsgDetail.hidden = locationServicesActive;
                self.lightningImgView.hidden = locationServicesActive;
                self.locationServicesBtn.hidden = locationServicesActive;
            }
        }
        
        for (UIView* v in self.tableFooter.subviews) {
            [v removeFromSuperview];
        }
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            
            _prevBtn = [UIButton appRectButtonWithTitle:kLangPrev target:self selector:@selector(prev:)];
            [_prevBtn setTitleColor:[UIColor appSecondaryTextColor] forState:UIControlStateNormal];
            _prevBtn.backgroundColor = [UIColor appTextAndIconColor];
            _nextBtn = [UIButton appRectButtonWithTitle:kLangNext target:self selector:@selector(next:)];
            
            [self.tableFooter addSubview:_prevBtn];
            [self.tableFooter addSubview:_nextBtn];
            
            [_nextBtn configureForAutoLayout];
            [_nextBtn autoPinEdgeToSuperviewEdge:ALEdgeRight];
            [_nextBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
            [_nextBtn autoSetDimensionsToSize:CGSizeMake(106, 40)];
            [_nextBtn autoSetDimension:ALDimensionHeight toSize:40];
            [_nextBtn autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.tableFooter withMultiplier:0.45];

            [_prevBtn configureForAutoLayout];
            [_prevBtn autoPinEdgeToSuperviewEdge:ALEdgeLeft];
            [_prevBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
            [_prevBtn autoSetDimension:ALDimensionHeight toSize:40];
            [_prevBtn autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.tableFooter withMultiplier:0.45];

        } else {
            
            _showBtn = [UIButton appRectButtonWithTitle:kLangShowOnMap target:self selector:@selector(reloadDirectionsOnMap)];
            [self.tableFooter addSubview:_showBtn];
            
            [_showBtn configureForAutoLayout];
            [_showBtn autoPinEdgeToSuperviewEdge:ALEdgeRight];
            [_showBtn autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
            [_showBtn autoSetDimension:ALDimensionHeight toSize:40];
            [_showBtn autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.tableFooter withMultiplier:0.8 relation:NSLayoutRelationLessThanOrEqual];
            [_showBtn autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.tableFooter withMultiplier:0.6 relation:NSLayoutRelationGreaterThanOrEqual];
        }
        
        [self updateUI];
    }
}

- (void) next:(id)sender {
    
    if ( [self.directionsView focusNextRouteSegment] ) {
        
        SectionModel* sm = [self.sectionModelArray objectAtIndex: self.directionsView.focusedRouteSegment ];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRouteLegSelected
                                                            object:sm
                                                          userInfo:@{ kLegIndex: @(sm.legIndex)
                                                                    , kStepIndex: @(sm.stepIndex)
                                                                    , kRouteSectionAccessibilityLabel: self.directionsView.accessibilityLabelForFocusedRouteSegment ?: @""
                                                                    }];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShowSelectedLegInList object:sm userInfo:@{ kRouteSectionIndex: @(self.directionsView.focusedRouteSegment), kNotificationSender: self}];
    }
}

- (void) prev:(id)sender {

    if ( [self.directionsView focusPrevRouteSegment] ) {
        
        SectionModel* sm = [self.sectionModelArray objectAtIndex: self.directionsView.focusedRouteSegment ];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRouteLegSelected
                                                            object:sm
                                                          userInfo:@{ kLegIndex: @(sm.legIndex)
                                                                    , kStepIndex: @(sm.stepIndex)
                                                                    , kRouteSectionAccessibilityLabel: self.directionsView.accessibilityLabelForFocusedRouteSegment ?: @""
                                                                    }];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShowSelectedLegInList object:sm userInfo:@{ kRouteSectionIndex: @(self.directionsView.focusedRouteSegment), kNotificationSender: self}];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ( [segue.destinationViewController isKindOfClass:[TransitSourcesTableViewController class]] ) {
        TransitSourcesTableViewController*  vc = segue.destinationViewController;
        
        vc.transitSources = self.transitSources;
        self.transitSources = nil;
        self.disableAppearanceSetup = YES;

    } else if ( [segue.destinationViewController isKindOfClass:[MPRouteSettingsViewController class]] ) {
        MPRouteSettingsViewController*  vc = segue.destinationViewController;

        vc.userRoleManager = Global.userRoleManager;

        __weak typeof(self)weakSelf = self;
        vc.onRouteSettingsChanged = ^{
            Global.routingData.latestRoutingRequestHash = 42;
            [weakSelf updateRouting];
        };
    }
}


#pragma mark - Location Services Turned On

- (IBAction) locationServicesTurnedOn:(id)sender {
    
    if ( self.locationServicesAlert ) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    UIAlertController* alert = [self alertControllerForLocationServicesState];
    
    if ( alert ) {
        [self presentViewController:alert animated:YES completion:nil];
        self.locationServicesAlert = alert;
    }
}

- (void) updateUI {
    _prevBtn.enabled = self.currentRoute && [self.directionsView canFocusPrevRouteSegment];
    _nextBtn.enabled = self.currentRoute && [self.directionsView canFocusNextRouteSegment];
    
    _nextBtn.alpha = _nextBtn.enabled ? 1 : 0.5;
    _prevBtn.alpha = _prevBtn.enabled ? 1 : 0.5;

    if ([_routing.travelMode isEqualToString:@"walking"])
        _walk.tintColor = [UIColor whiteColor];
    else if ([_routing.travelMode isEqualToString:@"driving"])
        _car.tintColor = [UIColor whiteColor];
    else if ([_routing.travelMode isEqualToString:@"bicycling"])
        _bike.tintColor = [UIColor whiteColor];
    else if ([_routing.travelMode isEqualToString:@"transit"])
        _train.tintColor = [UIColor whiteColor];
}

- (void) pop {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DisableHorizontalDirections" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CloseRouting" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
    self.origin = nil;
}


#pragma mark - Reload map data after location services turned On
- (void) reloadMapData:(NSNotification *)notification {
    
    if ( self.locationServicesAlert ) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }

    [self setupWhenAppeared];
}

- (void) onRouteResultReady:(NSNotification *)notification {
    
    if ( self.origin == nil ) {
        
        NSLog( @"onRouteResultReady: Ignoring result as we have not yet set origin" );
    
    } else {
        
        _showBtn.hidden = NO;
        self.currentRoute = notification.object;
        
        [Tracker trackEvent:kMPEventNameRouteCalculated parameters:@{ @"Origin"      : self.origin.name,
                                                                      @"Destination" : self.destination.name,
                                                                      @"Distance"    : self.currentRoute.distance ?: @(-1)}];
        
        [self config];
        
        [self configureReachabilityWarning: self.mp_isNetworkReachable ];
        [self.directionsView loadRoute:self.currentRoute withModels:self.sectionModelArray routingData:_routing];

        [self.spinner stopAnimating];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.reachabilitySpinner stopAnimating];
        });
        
        self.noRouteImageView.hidden = self.noRouteMessageLabel.hidden = self.currentRoute != nil;
        _showBtn.enabled = self.currentRoute != nil;
        _showBtn.alpha = _nextBtn.alpha = _prevBtn.alpha = self.currentRoute != nil ? 1 : 0.5;

        if ( self.currentRoute == nil ) {
            self.durationEstimate.text = @"";
            
        } else if ( [Global isUnlikelyDistance:self.currentRoute.distance.doubleValue] || [Global isUnlikelyDuration:self.currentRoute.duration.doubleValue] ) {
            
            self.durationEstimate.text = kLangDurationEstimateNotAvailable;
            
        } else {
            
            NSString*           overallTravelMode = _routing.travelMode;
            NSArray<NSNumber*>* travelModes = self.directionsView.travelModes;
            if ( travelModes.count == 1 ) {
                TRAVEL_MODE     usedTravelMode = (TRAVEL_MODE)[travelModes.firstObject unsignedIntegerValue];
                overallTravelMode = [NSString stringFromTravelMode:usedTravelMode];
            }
            
            NSAttributedString*   durationEstimate = [Global localizedStringForDuration: self.currentRoute.duration.floatValue travelMode:overallTravelMode];
            self.durationEstimate.text = [NSString stringWithFormat:@"%@ (%@)", [durationEstimate string], [Global getDistanceString:self.currentRoute.distance.floatValue]];
            
            self.durationEstimate.accessibilityLabel = [NSString stringWithFormat: kLangRouteAvailableAccHint, self.durationEstimate.text];
            [[MPAccessibilityHelper sharedInstance] setAccessibilityFocus:self.durationEstimate];
        }
    }
}

- (void)reloadDirectionsOnMap {

    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) {
        
        NSString*   snackbarMsg;

        if ( self.directionsView.focusedRouteSegment < self.sectionModelArray.count ) {
            SectionModel* sm = [self.sectionModelArray objectAtIndex: self.directionsView.focusedRouteSegment ];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShowSelectedLegInList object:sm userInfo:@{ kRouteSectionIndex: @(self.directionsView.focusedRouteSegment), kNotificationSender: self}];
            
            [self performSelector:@selector(drawRouteLegSelected) withObject:nil afterDelay:0.5];

            //Hide side menu/master view
            [self toggleSidebar];

        } else if ( self.origin == nil ) {
            snackbarMsg = kLangPleaseChooseStartingPoint;
            
        } else if ( self.destination == nil ) {
            snackbarMsg = kLangPleaseChooseDestination;
        }
        
        if ( snackbarMsg.length ) {
            TCFKA_MDSnackbar* s = [[TCFKA_MDSnackbar alloc] initWithText:snackbarMsg actionTitle:@"" duration:2];
            [s show];
        }
    }
}

- (void)drawRouteLegSelected {
    
    SectionModel *model = nil;
    
    model = [self.sectionModelArray objectAtIndex:0];
    
    if (model) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRouteLegSelected
                                                            object:model
                                                          userInfo:@{ kLegIndex: @(model.legIndex)
                                                                    , kStepIndex: @(model.stepIndex)
                                                                    , kRouteSectionAccessibilityLabel: self.directionsView.accessibilityLabelForFocusedRouteSegment ?: @""
                                                                    }];
    }
}

- (void)openDirectionsOnMap {
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPad) {
        
        [self toggleSidebar];
    }
}

- (void)openOriginSearch {
    
    PlacePickerSearchController* ppsc = [PlacePickerSearchController new];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:ppsc];
    if (_myLocation.geometry) {
        ppsc.myLocation = _myLocation;
    }
    
    ppsc.isOriginSearch = YES;
    
    if (!([self.origin.name containsString:@"position"] || [self.origin.name containsString:@"Estimated"])) {
        ppsc.selectedLocation = self.origin;
    }
    __weak typeof(self)weakSelf = self;
    [ppsc placePickerSelectCallback:^(MPLocation *location) {
        
        if ( location ) {
            weakSelf.origin = location;
            [weakSelf updateRouting];
        }
        
        [nav dismissViewControllerAnimated:YES completion:nil];
    }];
    
    self.disableAppearanceSetup = YES;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void)openDestinationSearch {
    
    PlacePickerSearchController* ppsc = [PlacePickerSearchController new];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:ppsc];
    if (_myLocation.geometry) {
        ppsc.myLocation = _myLocation;
    }
    
    ppsc.isOriginSearch = NO;
    
    if (!([self.destination.name containsString:@"position"] || [self.destination.name containsString:@"Estimated"])) {
        ppsc.selectedLocation = self.destination;
    }
    __weak typeof(self)weakSelf = self;
    [ppsc placePickerSelectCallback:^(MPLocation *location) {
        
        if ( location ) {
            weakSelf.destination = location;
            [weakSelf updateRouting];
        }

        [nav dismissViewControllerAnimated:YES completion:nil];
    }];
    
    self.disableAppearanceSetup = YES;
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (void) updateOriginDestinationButtonTitles
{
    NSString*   originTitle = self.origin ? [self getAddressForLocation:self.origin] : kLangChooseOrigin;
    [self.originButton setTitle:originTitle forState:UIControlStateNormal];
    
    NSString*   destinationTitle = self.destination ? [self getAddressForLocation:self.destination] : kLangChooseDestination;
    [self.destinationButton setTitle:destinationTitle forState:UIControlStateNormal];
}

- (void) updateRouting {

    self.durationEstimate.text = @"";
    if (self.origin) {
        
        //Hide the location services unavailable information.
        self.offlineMsg.hidden = YES;
        self.offlineMsgDetail.hidden = YES;
        self.lightningImgView.hidden = YES;
        self.locationServicesBtn.hidden = YES;
        
        [self.originButton setTitle:[self getAddressForLocation:self.origin] forState:UIControlStateNormal];
        [self.originButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    } else {
        [self.originButton setTitle:kLangChooseOrigin forState:UIControlStateNormal];
        [self.originButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    if (self.destination) {
        [self.destinationButton setTitle:[self getAddressForLocation:self.destination] forState:UIControlStateNormal];
        [self.destinationButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        [self.destinationButton setTitle:kLangChooseDestination forState:UIControlStateNormal];
        [self.destinationButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    VCMaterialDesignIcons* icon = nil;
    switch ( [_routing.travelMode as_TRAVEL_MODE] ) {
        case WALK:
            icon = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_walk fontSize:18];
            break;
        case DRIVE:
            icon = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_car fontSize:18];
            break;
        case BIKE:
            icon = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_bike fontSize:18];
            break;
        case TRANSIT:
            icon = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_bus fontSize:18];
            break;
    }
    [icon addAttribute:NSForegroundColorAttributeName value:[UIColor appSecondaryTextColor]];
    
    if (self.origin && self.destination) {
        
        if ( [self.origin.name isEqualToString:kLangMyPosition] && !_isLocationServicesOn && !MapsIndoors.positionProvider.latestPositionResult.geometry ) {
            
            //Hide the location services unavailable information.
            self.offlineMsg.hidden = NO;
            self.offlineMsgDetail.hidden = NO;
            self.lightningImgView.hidden = NO;
            self.locationServicesBtn.hidden = NO;
            
        } else {
            self.offlineMsg.hidden = YES;
            self.offlineMsgDetail.hidden = YES;
            self.lightningImgView.hidden = YES;
            self.locationServicesBtn.hidden = YES;
        }
        
        if ( MapsIndoors.positionProvider.latestPositionResult.geometry != nil ) {
            
            BOOL    originIsMyPosition = [self.origin.name isEqualToString:kLangMyPosition];
            BOOL    destinationIsMyPosition = [self.destination.name isEqualToString:kLangMyPosition];
            
            if ( originIsMyPosition || destinationIsMyPosition ) {

                CLLocationCoordinate2D  myLocation = [self.myLocation.geometry getCoordinate];
                CLLocationCoordinate2D  currLocation = [MapsIndoors.positionProvider.latestPositionResult.geometry getCoordinate];
                
                if ( (myLocation.latitude != currLocation.latitude) || (myLocation.longitude != currLocation.longitude) ) {
                    
                    self.myLocation = [[MPLocation alloc] initWithPoint:MapsIndoors.positionProvider.latestPositionResult.geometry andName:kLangMyPosition];
                    
                    if ( originIsMyPosition ) {
                        self.origin = self.myLocation;
                    }
                    if ( destinationIsMyPosition ) {
                        self.destination = self.myLocation;
                    }
                    
                    [[MPReverseGeocodingService sharedGeoCoder] reverseGeocodeLocation:self.origin completionHandler:^(GMSReverseGeocodeResponse * _Nullable result, NSError * _Nullable error) {
                        if ( self.myLocation.mp_firstReverseGeocodedAddress.length ) {
                            //TODO set description with builder instead
                            //self.myLocation.descr = self.myLocation.mp_firstReverseGeocodedAddress;
                            
                            [self.directionsView routeUpdated:self.currentRoute];
                            [self updateOriginDestinationButtonTitles];
                        }
                    }];
                }
            }
        }
        
        [_routing routingFrom: self.origin to: self.destination by:_routing.travelMode avoid:_avoids depart:nil arrive:nil];
        
        self.durationEstimate.accessibilityHint = kLangFindingRouteAccHint;
        [[MPAccessibilityHelper sharedInstance] setAccessibilityFocus:self.durationEstimate];
    }
}

- (void) orientationDidChange: (NSNotification*) notification {
    UIInterfaceOrientation o = [[UIApplication sharedApplication] statusBarOrientation];
    if (_currentOrientation != o) {
        [self setupWhenAppeared];
    }
    _currentOrientation = o;
}

- (void)config {
    
    self.sectionModelArray = [self.currentRoute sectionModelsForRequestTravelMode:[_routing.travelMode as_TRAVEL_MODE]];

    _routing.latestModelArray = self.sectionModelArray;
    
    if (self.sectionModelArray) {
        [[NSNotificationCenter defaultCenter] postNotificationName: @"RoutingMapDataReady"
                                                            object: _routing.latestRoute
                                                          userInfo: @{ @"models"    : self.sectionModelArray,
                                                                     @"origin"      : self.origin.type ?: @"google-place",
                                                                     @"destination" : self.destination.type ?: @"google-place"}];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self directionsView:self.directionsView didSelectRouteSegmentAtIndex:0 sectionModel:self.sectionModelArray[0] openOnMap:NO];
    });
}


#pragma mark - MPDirectionsViewDelegate

- (void)directionsView:(MPDirectionsView *)directionsView didSelectRouteSegmentAtIndex:(NSUInteger)index sectionModel:(SectionModel *)sectionModel {

    [self directionsView:directionsView didSelectRouteSegmentAtIndex:index sectionModel:sectionModel openOnMap:YES];
    
    float segmentPositionFactor = ((float) index +1) / (float)directionsView.numberOfRouteSegments;
    [Tracker trackEvent:@"Directions_Route_Segment_Selected" parameters:@{ @"Segment_Position_Factor" : @(segmentPositionFactor),
                                                                           @"Directions_Layout" : @"Vertical"
                                                                           }];
}

- (void)directionsView:(MPDirectionsView *)directionsView didSelectRouteSegmentAtIndex:(NSUInteger)index sectionModel:(SectionModel *)sectionModel openOnMap:(BOOL)openOnMap {

    directionsView.focusedRouteSegment = index;

    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRouteLegSelected
                                                        object:sectionModel
                                                      userInfo:@{ kLegIndex: @(sectionModel.legIndex)
                                                                , kStepIndex: @(sectionModel.stepIndex)
                                                                , kRouteSectionImages: [directionsView imagesForActionPoints]
                                                                , kRouteSectionAccessibilityLabel: self.directionsView.accessibilityLabelForFocusedRouteSegment ?: @""
                                                                }];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShowSelectedLegInList object:sectionModel userInfo:@{ kRouteSectionIndex: @(self.directionsView.focusedRouteSegment)
                                                                                                                                , kNotificationSender: self
                                                                                                                                , kRouteSectionImages: [directionsView imagesForActionPoints]
                                                                                                                                }];
    if ( openOnMap ) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openDirectionsOnMap" object:nil];
    }

    [directionsView collapseDirectionsDisplayIfShowing];
}

- (void) directionsView:(MPDirectionsView*)directionsView didSelectDirectionsForRouteSegmentAtIndex:(NSUInteger)routeSegmentIndex sectionModel:(SectionModel*)sectionModel {
    
    [directionsView toggleDirectionsDisplayForRouteSegment:routeSegmentIndex];
    
    [Tracker trackEvent:kMPEventNameDirectionsExpanded parameters:nil];
    
    directionsView.focusedRouteSegment = routeSegmentIndex;
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationRouteLegSelected
                                                            object:sectionModel
                                                          userInfo:@{ kLegIndex: @(sectionModel.legIndex)
                                                                    , kStepIndex: @(sectionModel.stepIndex)
                                                                    , kRouteSectionImages: [directionsView imagesForActionPoints]
                                                                    , kRouteSectionAccessibilityLabel: self.directionsView.accessibilityLabelForFocusedRouteSegment ?: @""
                                                                    }];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationShowSelectedLegInList object:sectionModel userInfo:@{ kRouteSectionIndex: @(self.directionsView.focusedRouteSegment)
                                                                                                                                    , kNotificationSender: self
                                                                                                                                    , kRouteSectionImages: [directionsView imagesForActionPoints]
                                                                                                                                    }];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openDirectionsOnMap" object:nil];
    }
}

- (void)directionsView:(MPDirectionsView *)directionsView didChangeFocusedRouteSegment:(NSUInteger)routeSegmentIndex {
    [self updateUI];
}

- (void) directionsView:(MPDirectionsView*)directionsView didRequestDisplayTransitSources:(NSArray<MPTransitAgency*>*)transitSources {
    
    self.transitSources = [transitSources copy];
    [self performSegueWithIdentifier:@"showTransitSourcesSegue" sender:self];
}


#pragma mark - Reachability warning

- (void) configureReachabilityWarning:(BOOL)isNetworkReachable {

    BOOL    warningShouldBeHidden = isNetworkReachable || self.currentRoute;
    
    if ( self.reachabilityWarningView.hidden != warningShouldBeHidden ) {
        
        if ( isNetworkReachable == NO ) {
            UIImage*    img = [VCMaterialDesignIcons iconWithCode:VCMaterialDesignIconCode.md_cloud_off fontSize:36.f].image;
            self.reachabilityWarningImageView.image = [img imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            self.reachabilityWarningLabel.text = kLangOfflineTryToReconnect;
            self.reachabilityWarningLabel.font = [[AppFonts sharedInstance] scaledFontForSize:11];
            self.reachabilityWarningLabel.textColor = [UIColor appTertiaryHighlightColor];
            
            if ( self.reachabilityWarningView.userInteractionEnabled == NO ) {
                self.reachabilityWarningView.userInteractionEnabled = YES;
                UITapGestureRecognizer* tapToReload = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(updateRouting)];
                [self.reachabilityWarningView addGestureRecognizer:tapToReload];
            }
        }
        
        CGFloat     heightDelta = warningShouldBeHidden ? - self.reachabilityWarningView.bounds.size.height : self.reachabilityWarningView.bounds.size.height;
        CGRect      r = self.directionsHeaderView.frame;
        r.size.height += heightDelta;
        
        [self.directionsHeaderView.superview setNeedsLayout];

        [UIView animateWithDuration:0.3 animations:^{
            self.reachabilityWarningView.hidden = warningShouldBeHidden;
            self.directionsHeaderView.frame = r;
            [self.directionsHeaderView.superview layoutIfNeeded];
        }];
    }
}


#pragma mark - Helpers

- (NSString*) getAddressForLocation:(MPLocation*)location {

    NSString*   addr;
    
    if ( (location == self.myLocation) && location.descr.length ) {
        addr = [NSString stringWithFormat:@"%@ (%@)", kLangMyPosition, location.descr];
    } else {
        addr = [Global getAddressForLocation:location];
    }
    
    return addr;
}

- (void) moveToCurrentLeg:(NSNotification *)notification {
    
    id  sender = notification.userInfo[kNotificationSender];
    
    if ( sender != self ) {
        NSInteger index = [notification.userInfo[kRouteSectionIndex] integerValue];
        
        self.directionsView.focusedRouteSegment = index;
    }
}


#pragma mark - Location tracking

- (void)locationTrackingOccured:(NSNotification *)notification {
    NSInteger legIndex = [notification.userInfo[kLegIndex] integerValue];
    NSInteger stepIndex = [notification.userInfo[kStepIndex] integerValue];
    for (NSInteger i = 0; i < self.sectionModelArray.count; i++) {
        SectionModel* model = self.sectionModelArray[i];
        if (model.legIndex == legIndex && (model.stepIndex == stepIndex || model.stepIndex == -1)) {
            self.directionsView.focusedRouteSegment = i;
            break;
        }
    }
}


#pragma mark - Route settings

- (void) onRouteSettingsTapped:(id)sender {

    [self performSegueWithIdentifier:@"routeSettingsSegue" sender:self];
}

@end
