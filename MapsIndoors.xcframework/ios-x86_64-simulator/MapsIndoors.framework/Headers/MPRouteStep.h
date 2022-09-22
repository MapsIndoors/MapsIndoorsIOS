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
#import "MPPoint.h"
#import "MPRouteProperty.h"
#import "MPRouteCoordinate.h"
#import "MPEncodedPolyline.h"
#import "MPTransitDetails.h"
#import "MPDefines.h"

@protocol MPRouteCoordinate
@end

@protocol MPRouteStep
@end


/**
 Route step model. A step is segment on a `MPRouteLeg` (`MPRouteLeg` is a segment on a `MPRoute`). The step contains start and end locations, distance and duration information, as well as navigational instructions.
 */
@interface MPRouteStep : JSONModel


/**
 Travel mode key. Can be walking, bicycling, driving and transit.
 */
@property (nonatomic, strong, nullable) NSString<Optional>* travel_mode;
/**
 End location coordinate and floor index
 */
@property (nonatomic, strong, nullable) MPRouteCoordinate<Optional>* end_location;
/**
 Start location coordinate and floor index
 */
@property (nonatomic, strong, nullable) MPRouteCoordinate<Optional>* start_location;
/**
 Distance of the step in meters.
 */
@property (nonatomic, strong, nullable) NSNumber<Optional>* distance;
/**
 Duration of the step in seconds, with specified travel mode `step.travel_mode`
 */
@property (nonatomic, strong, nullable) NSNumber<Optional>* duration;
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
@property (nonatomic, strong, nullable) NSString<Optional>* maneuver;
/**
 Encoded polyline for the step. Can de decoded with `[GMSPath pathFromEncodedPath:]`. Only long polylines may be encoded.
 */
@property (nonatomic, strong, nullable) MPEncodedPolyline<Optional>* polyline;
/**
 Polyline geometry for the step.
*/
@property (nonatomic, strong, nullable) NSMutableArray<MPRouteCoordinate*><MPRouteCoordinate,Optional>* geometry;
/**
 Textual instructions for the step. May not be specified.
 */
@property (nonatomic, strong, nullable) NSString<Optional>* html_instructions;
/**
 Way type for this step (part of the route). E.g. footway, steps, elevator, residential etc.
 */
@property _Nullable MPHighwayType highway;
/**
 Context of the step. May be `InsideBuilding`, `OutsideOnVenue` or a custom context e.g. `Security`
 */
@property (nonatomic, strong, nullable) NSString<Optional>* routeContext;
/**
 Substeps for the step. May be empty/nil.
 */
@property (nonatomic, strong, nullable) NSMutableArray<MPRouteStep*><MPRouteStep, Optional>* steps;
/**
 Transit details. May apply for travel mode `transit`.
 */
@property (nonatomic, strong, nullable) MPTransitDetails<Optional>* transit_details;

- (nullable MPPoint*)getActionPoint;
- (nullable NSNumber*)getStartFloorName;
- (nullable MPPoint *)getStartPoint;
- (nullable MPPoint *)getEndPoint;

@end
