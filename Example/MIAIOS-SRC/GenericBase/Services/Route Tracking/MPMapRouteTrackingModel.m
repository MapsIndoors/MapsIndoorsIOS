//
//  MPMapRouteTrackingModel.m
//  MapsIndoors App
//
//  Created by Michael Bech Hansen on 20/03/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//

#import "MPMapRouteTrackingModel.h"
#import "MPRouteTrackingSample.h"
#import <GoogleMaps/GoogleMaps.h>
#import <MapsIndoors/MapsIndoors.h>
#import "NSString+TRAVEL_MODE.h"
#import "GPSPositionProvider.h"


#if DEBUG && 1
    #define DEBUGLOG(fMT,...)  NSLog( @"[D] MPMapRouteTrackingModel.m(%d): "fMT,  __LINE__, __VA_ARGS__ )
#else
    #define DEBUGLOG(fMt,...)  /* Nada! */
#endif


@interface MPMapRouteTrackingModel ()

@property (nonatomic, weak) id<MPMapRouteTrackingModelDelegate>         delegate;

@property (nonatomic, readwrite) MPMapTrackingState                     trackingState;
@property (nonatomic, weak) GMSMapView*                                 map;
@property (nonatomic, strong) NSMutableArray<MPRouteTrackingSample*>*   positionSamples;
@property (nonatomic, weak) MPRouteTrackingSample*                      currentPosition;

@property (nonatomic, readwrite, strong, nullable) NSNumber*            floor;
@property (nonatomic, readwrite) double                                 zoom;
@property (nonatomic, readwrite) double                                 viewingAngle;
@property (nonatomic, readwrite) double                                 bearing;
@property (nonatomic, readwrite) CLLocationCoordinate2D                 mapCenter;
@property (nonatomic, readwrite) struct MPRouteSegmentPath              closestPointOnRoute;
@property (nonatomic, readwrite, strong, nullable) NSNumber*            overrideViewingAngle;
@property (nonatomic, readwrite, strong, nullable) NSNumber*            overrideZoom;

@property (nonatomic) BOOL                                              userGestureInProgress;

@end


@implementation MPMapRouteTrackingModel

+ (instancetype) newWithMap:(GMSMapView*)map delegate:(id<MPMapRouteTrackingModelDelegate>)delegate {

    return [[MPMapRouteTrackingModel alloc] initWithMap:map delegate:delegate];
}

- (instancetype) initWithMap:(GMSMapView*)map delegate:(id<MPMapRouteTrackingModelDelegate>)delegate {

    if ( map ) {

        self = [super init];
        if (self) {
            _delegate = delegate;
            _trackingMode = MPMapTrackingMode_DoNotTrack;
            _trackingState = MPMapTrackingState_NotTracking;
            _headingThreshold = 5;      // >5 degrees change needed
            _distanceThreshold = 5;     // >5m travel needed
            _accuracyThreshold = 10;    // <10m accuracy
            _map = map;
            _positionSamples = [NSMutableArray array];
            _zoom = DBL_MAX;
            _viewingAngle = DBL_MAX;
            _bearing = DBL_MAX;
            _mapCenter = kCLLocationCoordinate2DInvalid;
            _closestPointOnRoute.legIndex = -1;
            _closestPointOnRoute.stepIndex = -1;
        }
        DEBUGLOG( @"Created %p", self );

    } else {
        self = nil;
    }

    return self;
}

- (void) removeOutdatedSamples {

    if ( self.positionAgeLimit > 0 ) {

        while ( self.positionSamples.count ) {

            if (  self.positionSamples.lastObject.age > self.positionAgeLimit ) {
                [self.positionSamples removeObjectAtIndex:self.positionSamples.count -1];
            } else {
                break;
            }
        }
    }
}

- (CLLocationDirection) estimatedHeading {

    double          sumSin = 0, sumCos = 0;
    NSInteger       n = 5;
    NSUInteger      sumN = 0;

    for ( MPRouteTrackingSample* sample in self.positionSamples ) {

        if ( sample.heading ) {

            double heading = sample.heading.doubleValue;
            heading *= M_PI/180.;

            sumSin += sin(heading) * n;
            sumCos += cos(heading) * n;
            sumN += n;
            --n;
        }

        if ( (n <= 0) || (sample.age > 5) ) {
            break;
        }
    }

    CLLocationDirection avgBearing = -1;
    if ( sumN ) {

        double bearingInRad = atan2( sumSin/(double)sumN, sumCos/(double)sumN );
        avgBearing = (bearingInRad*180.) / M_PI;

        if ( avgBearing < 0 ) {
            avgBearing += 360;
        }
    }

    return avgBearing;
}

- (MPRouteTrackingSample*) currentPosition {

    return self.positionSamples.firstObject;
}


#pragma mark - Debug

- (NSString*) debugDescription {

    NSMutableString*    s = [NSMutableString stringWithFormat:@"<MPMapRouteTrackingModel %p: mode=%@, state=%@", self, [self stringFromTrackingMode:self.trackingMode], [self stringFromTrackingState:self.trackingState]];

    #if 0
        [s appendFormat:@"\n  .headingThreshold      = %@", @(self.headingThreshold)];
        [s appendFormat:@"\n  .distanceThreshold     = %@", @(self.distanceThreshold)];
        [s appendFormat:@"\n  .accuracyThreshold     = %@", @(self.accuracyThreshold)];
        [s appendFormat:@"\n  .positionAgeLimit      = %@", @(self.positionAgeLimit)];
        [s appendFormat:@"\n  .positionSamples.count = %@", @(self.positionSamples.count)];

        if ( self.positionSamples.count ) {

            for ( MPRouteTrackingSample* sample in self.positionSamples ) {
                [s appendFormat:@"\n    %@", sample.debugDescription];
            }
        }

        [s appendString:@"\n"];
    #endif

    [s appendString:@">"];

    return [s copy];
}

- (NSString*) stringFromTrackingMode:(MPMapTrackingMode)trackingMode {

    switch ( trackingMode ) {
        case MPMapTrackingMode_DoNotTrack:          return @"DoNotTrack";
        case MPMapTrackingMode_Follow:              return @"Follow";
        case MPMapTrackingMode_FollowWithHeading:   return @"FollowWithHeading";
    }

    return [NSString stringWithFormat:@"trackingMode=%@", @(trackingMode)];
}

- (NSString*) stringFromTrackingState:(MPMapTrackingState)trackingState {

    switch ( trackingState ) {
        case MPMapTrackingState_NotTracking:            return @"NotTracking";
        case MPMapTrackingState_Following:              return @"Following";
        case MPMapTrackingState_FollowingWithHeading:   return @"FollowingWithHeading";
        case MPMapTrackingState_Suspended:              return @"Suspended";
            break;
    }


    return [NSString stringWithFormat:@"trackingState=%@", @(trackingState)];
}


#pragma mark - Map tracking

- (void) mapView:(GMSMapView*)mapView idleAtCameraPosition:(GMSCameraPosition *)position {

    DEBUGLOG( @"%s", __PRETTY_FUNCTION__ );

    if ( self.userGestureInProgress ) {

        GMSProjection*  mapProjection = mapView.projection;
        CGPoint     p1 = [mapProjection pointForCoordinate:position.target];
        CGPoint     p2 = [mapProjection pointForCoordinate:self.currentPosition.geometry.getCoordinate];

        CGFloat xDist = (p2.x - p1.x);
        CGFloat yDist = (p2.y - p1.y);
        CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist));

        // Dont suspend on "small" movements:
        if ( distance > 33 ) {      // 22 is too little, 44 too much...
            [self suspendTracking];
        } else {
            [self updateSuggestedMapPresentation];  // Re-center
        }

        self.userGestureInProgress = NO;
    }
}

- (void) mapView:(GMSMapView*)mapView willMove:(BOOL)gesture {

    DEBUGLOG( @"%s: gesture=%@", __PRETTY_FUNCTION__, @(gesture) );

    self.userGestureInProgress = gesture;
}

- (void) onPositionUpdate:(MPPositionResult*)positionResult {

    DEBUGLOG( @"%s", __PRETTY_FUNCTION__ );

    if ( positionResult ) {
        MPRouteTrackingSample*  sample = [MPRouteTrackingSample newWithPosition:positionResult];
        [self.positionSamples insertObject:sample atIndex:0];

        [self removeOutdatedSamples];

        NSLog( @"%@", self.debugDescription );

        if ( self.userGestureInProgress == NO ) {

            [self updateSuggestedMapPresentation];
        }
    }
}

- (void) updateSuggestedMapPresentation {

    CLLocationCoordinate2D  coord = [self.currentPosition.geometry getCoordinate];

    if ( CLLocationCoordinate2DIsValid(coord) && (coord.latitude != 0.0f) ) {

        [self updateClosestPointOnRoute];
        [self setupOverrideZoomForTrackingMode];

        NSNumber* newTrackedFloor = @(self.currentPosition.geometry.z);
        if ( !newTrackedFloor || !self.floor || ![newTrackedFloor isEqualToNumber:self.floor]) {
            self.floor = newTrackedFloor;
            [self onFloorChanged];
        }

        self.zoom = self.overrideZoom ? self.overrideZoom.doubleValue : self.map.camera.zoom;
        self.viewingAngle = self.overrideViewingAngle ? self.overrideViewingAngle.doubleValue : self.map.camera.viewingAngle;
        self.bearing = (self.trackingMode == MPMapTrackingMode_Follow) ? 0 : self.estimatedHeading;

        CLLocationCoordinate2D  mapCenter = self.map.camera.target;
        double                  movement = GMSGeometryDistance( coord, mapCenter );
        BOOL                    zoomChanged = (self.zoom != self.map.camera.zoom);
        BOOL                    viewingAngleChanged = (self.viewingAngle != self.map.camera.viewingAngle);
        BOOL                    bearingChanged = (self.bearing != self.map.camera.bearing);
        BOOL                    positionChanged = (movement >= 1);

        if ( zoomChanged || viewingAngleChanged || bearingChanged || positionChanged ) {

            self.mapCenter = coord;

            DEBUGLOG( @"Updating map: zoomChanged=%@, viewingAngleChanged=%@, bearingChanged=%@, positionChanged=%@,",
                     @(zoomChanged),
                     @(viewingAngleChanged),
                     @(bearingChanged),
                     @(positionChanged) );

            [self onMapPresentationParametersChanged];
        }
    }

    self.overrideViewingAngle = nil;
    self.overrideZoom = nil;
}


#pragma mark - State management

- (void) setTrackingMode:(MPMapTrackingMode)trackingMode {

    if ( _trackingMode != trackingMode ) {

        DEBUGLOG( @"trackingMode %@ => %@", [self stringFromTrackingMode:_trackingMode], [self stringFromTrackingMode:trackingMode] );

        _trackingMode = trackingMode;

        [self updateTrackingStateFromTrackingMode];
        [self setupOverrideViewingAngleForTrackingMode];
        [self setupOverrideZoomForTrackingMode];
        [self updateSuggestedMapPresentation];
    }
}

- (void) setTrackingState:(MPMapTrackingState)trackingState {

    if ( _trackingState != trackingState ) {
        DEBUGLOG( @"trackingState %@ => %@", [self stringFromTrackingState:_trackingState], [self stringFromTrackingState:trackingState] );
        _trackingState = trackingState;
        [self onTrackingStateChanged];
    }
}

- (void) setupOverrideViewingAngleForTrackingMode {

    switch ( self.trackingMode ) {
        case MPMapTrackingMode_DoNotTrack:          self.overrideViewingAngle = nil;        break;
        case MPMapTrackingMode_Follow:              self.overrideViewingAngle = @(0);       break;
        case MPMapTrackingMode_FollowWithHeading:   self.overrideViewingAngle = @(45);      break;
    }
}

- (void) setupOverrideZoomForTrackingMode {

    self.overrideZoom = nil;

    if ( self.turnByTurnMode && self.isTracking && self.route && (self.closestPointOnRoute.legIndex != -1) ) {

        // Setup a travelmode dependent zoom level when in routing+turn-by-turn mode:
        MPRouteLeg*     leg = self.route.legs[ self.closestPointOnRoute.legIndex ];
        MPRouteStep*    step = leg.steps.firstObject;
        MPTravelMode    travelMode = [step.travel_mode as_MPTravelMode];

        switch ( travelMode ) {
            case MPTravelModeWalking:
                self.overrideZoom = @21;
                break;

            case MPTravelModeBicycling:
                self.overrideZoom = @20;
                break;

            case MPTravelModeDriving:
            case MPTravelModeTransit:
            case MPTravelModeUnknown: {
                // Approximate a suitable zoomlevel by comparing leg-distance with map width.
                // (Alternatively compute zoom level fitting the leg-geometry)
                double          legDistance = leg.distance.doubleValue;
                double          mapWidth = GMSGeometryDistance( self.map.projection.visibleRegion.nearLeft, self.map.projection.visibleRegion.nearRight );
                double          percentageDisplayed = legDistance / mapWidth;

                if ( percentageDisplayed < 25 ) {
                    self.overrideZoom = @20;
                } else if ( percentageDisplayed < 50 ) {
                    self.overrideZoom = @19;
                } else {
                    self.overrideZoom = @18;
                }
                break;
            }
        }

        // DEBUGLOG( @"travelMode=%@, overrideZoom=%@", step.travel_mode, self.overrideZoom );
    }
}

- (BOOL) isTracking {

    return (self.trackingState == MPMapTrackingState_Following) || (self.trackingState == MPMapTrackingState_FollowingWithHeading);
}

- (void) updateTrackingStateFromTrackingMode {

    switch ( self.trackingMode ) {
        case MPMapTrackingMode_DoNotTrack:
            self.trackingState = MPMapTrackingState_NotTracking;
            break;
        case MPMapTrackingMode_Follow:
            self.trackingState = MPMapTrackingState_Following;
            break;
        case MPMapTrackingMode_FollowWithHeading:
            self.trackingState = MPMapTrackingState_FollowingWithHeading;
            break;
    }
}

- (void) suspendTracking {

    switch ( self.trackingState ) {
        case MPMapTrackingState_Following:
        case MPMapTrackingState_FollowingWithHeading:
            self.trackingState = MPMapTrackingState_Suspended;
            break;

        case MPMapTrackingState_NotTracking:
        case MPMapTrackingState_Suspended:
            // Nothing to do
            break;
    }
}

- (void) toggleTrackingMode {

    switch ( self.trackingState ) {
        case MPMapTrackingState_NotTracking:
            self.trackingMode = MPMapTrackingMode_Follow;
            break;
        case MPMapTrackingState_Following:
            if (self.isTurnByTurnApplicable) {
                self.trackingMode = MPMapTrackingMode_FollowWithHeading;
            }
            break;
        case MPMapTrackingState_FollowingWithHeading:
            self.trackingMode = MPMapTrackingMode_Follow;
            break;
        case MPMapTrackingState_Suspended:
            // Do not change trackingMode directly - we resume tracking with the mode that was active when resuming.
            [self updateTrackingStateFromTrackingMode];
            [self setupOverrideViewingAngleForTrackingMode];
            [self setupOverrideZoomForTrackingMode];
            [self updateSuggestedMapPresentation];
            if ( self.isTracking ) {

                [self onFloorChanged];
                
                if ( self.route ) {
                    [self onClosestPointOnRouteChanged];
                }
            }
            break;
    }
}


#pragma mark - Route and turn-by-turn support

- (void) setRoute:(MPRoute*)route {

    if ( _route != route ) {
        _route = route;

        [self updateClosestPointOnRoute];

        if ( _route == nil ) {
            self.turnByTurnMode = NO;
        }
    }
}

- (void) updateClosestPointOnRoute {

    MPRouteSegmentPath  newPointOnRoute = { -1, -1 };

    if ( /*self.turnByTurnMode &&*/ self.route ) {

        MPPoint*    coord = self.currentPosition.geometry;
        NSNumber*   floor = @(self.currentPosition.geometry.z);

        newPointOnRoute = [self.route findNearestRouteSegmentPathFromPoint:coord floor:floor];
    }

    if ( (self.closestPointOnRoute.legIndex != newPointOnRoute.legIndex) || (self.closestPointOnRoute.stepIndex != newPointOnRoute.stepIndex) ) {

        self.closestPointOnRoute = newPointOnRoute;
        [self onClosestPointOnRouteChanged];
    }
}

- (void) setTurnByTurnMode:(BOOL)turnByTurnMode {

    if ( _turnByTurnMode != turnByTurnMode ) {
        _turnByTurnMode = turnByTurnMode;

        [self updateClosestPointOnRoute];

        if ( _turnByTurnMode ) {
            self.trackingMode = MPMapTrackingMode_FollowWithHeading;
            [self setupOverrideViewingAngleForTrackingMode];
            [self setupOverrideZoomForTrackingMode];
            [self updateSuggestedMapPresentation];
        }
    }
}

- (BOOL) isTurnByTurnApplicable {
    return MapsIndoors.positionProvider.class != GPSPositionProvider.class;
}


#pragma mark - MPMapRouteTrackingModelDelegate handling

- (void) onMapPresentationParametersChanged {

    DEBUGLOG( @"%s", __PRETTY_FUNCTION__ );

    [self.delegate mapRouteTrackingModel:self didDetermineMapCenter:self.mapCenter zoom:self.zoom bearing:self.bearing viewingAngle:self.viewingAngle floor:self.floor];
}

- (void) onFloorChanged {

    DEBUGLOG( @"%s", __PRETTY_FUNCTION__ );

    [self.delegate mapRouteTrackingModel:self didSwitchFloor:self.floor];
}

- (void) onClosestPointOnRouteChanged {

    DEBUGLOG( @"%s", __PRETTY_FUNCTION__ );

    [self.delegate mapRouteTrackingModel:self didMoveToRouteLegIndex:self.closestPointOnRoute.legIndex stepIndex:self.closestPointOnRoute.stepIndex onRoute:self.route];
}

- (void) onTrackingStateChanged {

    DEBUGLOG( @"%s gesture=%@", __PRETTY_FUNCTION__, @(self.userGestureInProgress) );

    [self.delegate mapRouteTrackingModel:self didChangeTrackingState:self.trackingState userGesture:self.userGestureInProgress];
}

@end
