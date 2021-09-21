//
//  AppFlowController.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 08/06/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "AppFlowController.h"

#import "AppNotifications.h"
#import "MapViewController.h"

#import <MapsIndoors/MapsIndoors.h>
#import <UIKit/UIKit.h>

typedef void(^AppFlowLocationResolveBlock)(MPLocation*);


@interface AppFlowController ()

@property (nonatomic, readwrite)        BOOL                isBusy;

@property (nonatomic, strong, nullable) NSString*           locationIdForDetails;

@property (nonatomic, strong, nullable) MPPoint*            routeOriginPoint;
@property (nonatomic, strong, nullable) NSString*           routeOriginLocationId;
@property (nonatomic, strong, nullable) MPPoint*            routeDestinationPoint;
@property (nonatomic, strong, nullable) NSString*           routeDestinationLocationId;
@property (nonatomic, strong, nullable) NSString*           routeTravelMode;
@property (nonatomic, strong, nullable) NSArray<NSString*>* routeRestrictions;

@end


@implementation AppFlowController

+ (instancetype) sharedInstance {

    static AppFlowController* _sharedAppFlowController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAppFlowController = [AppFlowController new];
    });

    return _sharedAppFlowController;
}


- (void) setMainUiIsReady:(BOOL)mainUiIsReady {

    if ( _mainUiIsReady != mainUiIsReady ) {
        _mainUiIsReady = mainUiIsReady;

        if ( self.routeOriginPoint || self.routeDestinationPoint || self.routeOriginLocationId || self.routeDestinationLocationId ) {
            
            [self presentRouteFrom:self.routeOriginPoint
                      fromLocation:self.routeOriginLocationId
                                to:self.routeDestinationPoint
                        toLocation:self.routeDestinationLocationId
                        travelMode:self.routeTravelMode
                             avoid:self.routeRestrictions];

        } else if ( self.locationIdForDetails ) {

            [self presentDetailsScreenForLocationWitId:self.locationIdForDetails];
        }
    }
}


#pragma mark - Location Details

- (void) presentDetailsScreenForLocationWitId:(NSString*)locationId {

    self.locationIdForDetails = locationId;

    if ( self.mainUiIsReady ) {

        NSString*   locationId = self.locationIdForDetails;
        self.locationIdForDetails = nil;
        self.isBusy = YES;

        [MapsIndoors.locationsProvider getLocationWithId:locationId completionHandler:^(MPLocation * _Nullable location, NSError * _Nullable error) {

            [[NSNotificationCenter defaultCenter] postNotificationName:@"MapLocationTapped" object:location];
            self.isBusy = NO;
        }];

    } else {
        NSLog( @"%s: Delayed presentation of location details for %@", __PRETTY_FUNCTION__, locationId );
    }
}


#pragma mark - Routes

- (void) presentRouteFrom:(nullable MPPoint*)from
             fromLocation:(nullable NSString*)fromLocation
                       to:(nullable MPPoint*)to
               toLocation:(nullable NSString*)toLocation
               travelMode:(nullable NSString*)travelMode
                    avoid:(nullable NSArray<NSString*>*)restrictions
{
    self.routeOriginPoint = from;
    self.routeOriginLocationId = fromLocation;
    self.routeDestinationPoint = to;
    self.routeDestinationLocationId = toLocation;
    self.routeTravelMode = travelMode;
    self.routeRestrictions = restrictions;

    if ( self.mainUiIsReady ) {

        // Grab copy of parameters and reset instance-vars:
        MPPoint*            routeOriginPoint = self.routeOriginPoint;
        NSString*           routeOriginLocationId = self.routeOriginLocationId;
        MPPoint*            routeDestinationPoint = self.routeDestinationPoint;
        NSString*           routeDestinationLocationId = self.routeDestinationLocationId;
        NSString*           routeTravelMode = self.routeTravelMode;
        NSArray<NSString*>* routeRestrictions = self.routeRestrictions;

        self.routeOriginPoint = nil;
        self.routeOriginLocationId = nil;
        self.routeDestinationPoint = nil;
        self.routeDestinationLocationId = nil;
        self.routeTravelMode = nil;
        self.routeRestrictions = nil;
        self.isBusy = YES;

        [self resolveLocationId:routeOriginLocationId overridePoint:routeOriginPoint completion:^(MPLocation* originLoc) {

            [self resolveLocationId:routeDestinationLocationId overridePoint:routeDestinationPoint completion:^(MPLocation* destinationLoc) {

                NSLog( @"()=>> route from %@ to %@ by %@ (avoiding %@)", originLoc.name, destinationLoc.name, routeTravelMode, [routeRestrictions componentsJoinedByString:@","] ?: @"nothing" );

                [AppNotifications postRouteRequestNotificationWithOrigin:originLoc destination:destinationLoc travelMode:routeTravelMode avoids:routeRestrictions];

                self.isBusy = NO;
            }];
        }];

    } else {
        NSLog( @"%s: Delayed presentation of route from (%@,%@) to (%@,%@) avoid=[%@], mode=%@", __PRETTY_FUNCTION__,
              self.routeOriginLocationId, [self.routeOriginPoint latLngString],
              self.routeDestinationLocationId, [self.routeDestinationPoint latLngString],
              [self.routeRestrictions componentsJoinedByString:@", "],
              self.routeTravelMode
              );
    }
}


- (void) resolveLocationId:(NSString*)locId overridePoint:(MPPoint*)locPoint completion:(AppFlowLocationResolveBlock)completion {

    if ( locId ) {

        [MapsIndoors.locationsProvider getLocationWithId:locId completionHandler:^(MPLocation * _Nullable location, NSError * _Nullable error) {
            completion( location );
        }];

    } else if ( locPoint ) {

        MPLocationUpdate* locationBuilder = [MPLocationUpdate updateWithLocation:[MPLocation new]];
        locationBuilder.name = [locPoint latLngString];
        locationBuilder.position = [locPoint getCoordinate];
        locationBuilder.floor = [locPoint zIndex];

        completion( locationBuilder.location );

    } else {

        completion( nil );
    }
}


- (MPMapControl*) currentMapControl {
    
    /*
     View hierarchy in freshly launched app:

     (lldb) po [UIViewController _printHierarchy]
     <ContainerViewController 0x104e084f0>, state: appeared, view: <UIView 0x104d1d950>
        | <UISplitViewController 0x104e24930>, state: appeared, view: <_UISplitViewControllerPanelImplView 0x104e32210>
        |    | <MasterNavigationController 0x10589f600>, state: appeared, view: <UILayoutContainerView 0x108b0b300>
        |    |    | <VenueSelectorController 0x104e2f540>, state: disappeared, view: <UITableView 0x10982c000> not in the window
        |    |    | <MasterViewController 0x104d165d0>, state: appearing, view: <UITableView 0x1058c8000>
        |    | <UINavigationController 0x1058a8c00>, state: appeared, view: <UILayoutContainerView 0x104e3ede0>
        |    |    | <MapViewController 0x1058a7000>, state: appeared, view: <UIView 0x104e16880>
        |    |    |    | <FloatingActionMenuController 0x104d40af0>, state: appeared, view: <UIView 0x104d290b0>
        |    |    |    | <HorizontalRoutingController 0x104d415a0>, state: appeared, view: <UIView 0x104d450b0>

    */

    MPMapControl*   mapControl;

    id  navigationController = self.splitViewController.viewControllers.lastObject;
    if ( [navigationController isKindOfClass:UINavigationController.class] ) {

        if ( [((UINavigationController*)navigationController).viewControllers.firstObject isKindOfClass:MapViewController.class] ) {

            MapViewController*  mapViewController = ((UINavigationController*)navigationController).viewControllers.firstObject;
            mapControl = mapViewController.mapControl;
        }
    }

    return mapControl;
}


@end
