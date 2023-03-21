//
//  MPRouteAction.h
//  Indoor
//
//  Created by Daniel Nielsen on 12/2/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#define kSTRAIGHT_MANEUVER @"Straight"
#define kLEFT_UP_MANEUVER @"Left"
#define kLEFT_DOWN_MANEUVER @"LeftDown"
#define kLEFT_MANEUVER @"Left"
#define kRIGHT_UP_MANEUVER @"RightUp"
#define kRIGHT_DOWN_MANEUVER @"RightDown"
#define kRIGHT_MANEUVER @"Right"
#define kU_TURN_MANEUVER @"UTurn"
#define kDOWN_MANEUVER @"Down"
#define kUP_MANEUVER @"Up"
#define kSTART_MANEUVER @"Start"
#define kDESTINATION_MANEUVER @"Destination"

enum MPRouteActionType {
    STRAIGHT_COMPASS_HEADING_ACTION = 1,
    TURN_ACTION = 6,
    Z_LEVEL_ACTION = 3,
    DESTINATION_ACTION = 5,
    START_ACTION = 4
};

enum MPRouteActionDirection {
    LEFT_DIRECTION = 270,
    RIGHT_DIRECTION = 90,
    LEFT_SHARP_DIRECTION = 225,
    RIGHT_SHARP_DIRECTION = 135,
    LEFT_OBTUSE_DIRECTION = 315,
    RIGHT_OBTUSE_DIRECTION = 45,
    U_TURN_DIRECTION = 180,
    UP_DIRECTION = 1,
    DOWN_DIRECTION = 0
};

#import "JSONModel.h"
#import "MPEncodedPolylineInternal.h"
#import "MPRouteCoordinateInternal.h"
#import "MPRoutePropertyInternal.h"
#import "MPRouteStepInternal.h"
#import "MPTransitDetailsInternal.h"
@import MapsIndoors;

@protocol MPRouteCoordinateInternal;
@protocol MPRouteStepInternal;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Route step model. A step is segment on a `MPRouteLegInternal` (`MPRouteLegInternal` is a segment on a `MPRoute`). The step contains start and end locations, distance and duration information, as well as navigational instructions.
 */
@interface MPRouteStepInternal : JSONModel <MPRouteStep>

/**
 Travel mode key. Can be walking, bicycling, driving and transit.
 */
@property (nonatomic, copy) NSString* travel_mode;
/**

 */
@property (nonatomic, strong) MPRouteCoordinateInternal* end_location;
/**
 Start location coordinate and floor index
 */
@property (nonatomic, strong) MPRouteCoordinateInternal* start_location;
/**
 Distance of the step in meters.
 */
@property (nonatomic, strong) NSNumber* distance;
/**
 Duration of the step in seconds, with specified travel mode `step.travel_mode`
 */
@property (nonatomic, strong) NSNumber* duration;
/**
 Maneuver value for the step. Possible values are:
     straight,
     turn-left,
     turn-right,
     turn-sharp-left,
     turn-sharp-right,
     turn-slight-left,
     turn-slight-right,
     uturn-left,
     uturn-right
 */
@property (nonatomic, copy) NSString* maneuver;
/**
 Encoded polyline for the step. Can de decoded with `[MPPath pathFromEncodedPath:]`. Only long polylines may be encoded.
 */
@property (nonatomic, strong, nullable) MPEncodedPolylineInternal* polyline;
/**
 Polyline geometry for the step.
*/
@property (nonatomic, strong) NSArray<id<MPRouteCoordinate>><MPRouteCoordinateInternal>* geometry;
/**
 Textual instructions for the step. May not be specified.
 */
@property (nonatomic, copy) NSString* html_instructions;
/**
 Way type for this step (part of the route). E.g. footway, steps, elevator, residential etc.
 */
@property (nonatomic, strong, nullable) MPHighway* highway;
/**
 Context of the step. May be `InsideBuilding`, `OutsideOnVenue` or a custom context e.g. `Security`
 */
@property (nonatomic, copy, nullable) NSString* routeContext;
/**
 Substeps for the step. May be empty/nil.
 */
@property (nonatomic, strong) NSArray<id<MPRouteStep>><MPRouteStepInternal>* steps;
/**
 Transit details. May apply for travel mode `transit`.
 */
@property (nonatomic, strong, nullable) MPTransitDetailsInternal* transit_details;

- (nullable MPPoint*)getActionPoint;
- (nullable NSNumber*)getStartFloorName;
- (nullable MPPoint*)getStartPoint;
- (nullable MPPoint*)getEndPoint;

// Moved from MPRouteStep+Mutable
@property (nonatomic, strong, nullable) NSMutableArray<id<MPRouteCoordinate>><MPRouteCoordinateInternal>* mutableGeometry;
@property (nonatomic, strong, nullable) NSMutableArray<id<MPRouteStep>><MPRouteStepInternal>* mutableSteps;


- (void)setGeom:(nonnull NSArray<id<MPRouteCoordinate>><MPRouteCoordinateInternal>*)geometry;

- (void)setDist:(NSNumber*)distance;

- (void)setDur:(NSNumber*)duration;

@end

NS_ASSUME_NONNULL_END
