//
//  MPMapRouteTrackingModel.h
//  MapsIndoors App
//
//  Created by Michael Bech Hansen on 20/03/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@class GMSMapView;
@class GMSCameraPosition;
@class MPPositionResult;
@protocol MPMapRouteTrackingModelDelegate;
@class MPRoute;
struct MPRouteSegmentPath;


typedef NS_ENUM( NSUInteger, MPMapTrackingMode ) {
    MPMapTrackingMode_DoNotTrack,
    MPMapTrackingMode_Follow,
    MPMapTrackingMode_FollowWithHeading,
};

typedef NS_ENUM( NSUInteger, MPMapTrackingState ) {
    MPMapTrackingState_NotTracking,
    MPMapTrackingState_Following,
    MPMapTrackingState_FollowingWithHeading,
    MPMapTrackingState_Suspended
};


NS_ASSUME_NONNULL_BEGIN

@interface MPMapRouteTrackingModel : NSObject

// Configuration/inputs:
@property (nonatomic) MPMapTrackingMode                         trackingMode;
@property (nonatomic, readonly) MPMapTrackingState              trackingState;
@property (nonatomic, strong, nullable) MPRoute*                route;
@property (nonatomic) BOOL                                      turnByTurnMode;
@property (nonatomic, readonly) BOOL                            isTracking;


// Outputs / calculated values:
@property (nonatomic, readonly, strong, nullable) NSNumber*     floor;
@property (nonatomic, readonly) double                          zoom;
@property (nonatomic, readonly) double                          viewingAngle;
@property (nonatomic, readonly) double                          bearing;
@property (nonatomic, readonly) CLLocationCoordinate2D          mapCenter;
@property (nonatomic, readonly) struct MPRouteSegmentPath       closestPointOnRoute;
@property (nonatomic, readonly) BOOL                            isTurnByTurnApplicable;


/**
 Heading changes need to be >= this value to be considered.
 */
@property (nonatomic) CLLocationDirection                       headingThreshold;

/**
 Distance changes need to be >= this value to be considered.
 */
@property (nonatomic) CLLocationDistance                        distanceThreshold;

/**
 The accuracy needs to be <= this value to be considered.
 */
@property (nonatomic) CLLocationDistance                        accuracyThreshold;

/**
 The maximum age that position samples are allowed to be
 */
@property (nonatomic) NSTimeInterval                            positionAgeLimit;

@property (nonatomic, readonly) CLLocationDirection             estimatedHeading;


+ (instancetype) newWithMap:(GMSMapView*)map delegate:(id<MPMapRouteTrackingModelDelegate>)delegate;
- (instancetype) initWithMap:(GMSMapView*)map delegate:(id<MPMapRouteTrackingModelDelegate>)delegate;
- (instancetype) init NS_UNAVAILABLE;

- (void) toggleTrackingMode;

- (void) onPositionUpdate:(MPPositionResult*)positionResult;
- (void) suspendTracking;

- (void) mapView:(GMSMapView*)mapView idleAtCameraPosition:(GMSCameraPosition*)position;
- (void) mapView:(GMSMapView*)mapView willMove:(BOOL)gesture;

@end


@protocol MPMapRouteTrackingModelDelegate <NSObject>

@required
- (void) mapRouteTrackingModel:(MPMapRouteTrackingModel*)tracker
         didDetermineMapCenter:(CLLocationCoordinate2D)mapCenter
                          zoom:(double)zoom
                       bearing:(double)bearing
                  viewingAngle:(double)viewingAngle
                         floor:(NSNumber*)floor
                              ;

@required
- (void) mapRouteTrackingModel:(MPMapRouteTrackingModel*)tracker
                didSwitchFloor:(NSNumber*)floor
                              ;

@required
- (void) mapRouteTrackingModel:(MPMapRouteTrackingModel*)tracker
        didMoveToRouteLegIndex:(NSInteger)legIndex
                     stepIndex:(NSInteger)stepIndex
                       onRoute:(MPRoute*)route
                              ;


@required
- (void) mapRouteTrackingModel:(MPMapRouteTrackingModel*)tracker
        didChangeTrackingState:(MPMapTrackingState)state
                   userGesture:(BOOL)userGesture
                              ;

@end

NS_ASSUME_NONNULL_END
