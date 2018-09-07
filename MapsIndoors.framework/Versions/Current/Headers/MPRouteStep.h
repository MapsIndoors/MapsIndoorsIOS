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

#import "MPJSONModel.h"
#import "MPPoint.h"
#import "MPRouteProperty.h"
#import "MPRouteCoordinate.h"
#import "MPEncodedPolyline.h"
#import "MPTransitDetails.h"

@protocol MPRouteCoordinate
@end

@protocol MPRouteStep
@end

@interface MPRouteStep : MPJSONModel

@property (nonatomic, strong, nullable) NSString<Optional>* travel_mode;
@property (nonatomic, strong, nullable) MPRouteCoordinate<Optional>* end_location;
@property (nonatomic, strong, nullable) MPRouteCoordinate<Optional>* start_location;
@property (nonatomic, strong, nullable) NSNumber<Optional>* distance;
@property (nonatomic, strong, nullable) NSNumber<Optional>* duration;
@property (nonatomic, strong, nullable) NSString<Optional>* maneuver;
@property (nonatomic, strong, nullable) MPEncodedPolyline<Optional>* polyline;
@property (nonatomic, strong, nullable) NSMutableArray<MPRouteCoordinate*><MPRouteCoordinate,Optional>* geometry;
@property (nonatomic, strong, nullable) NSString<Optional>* html_instructions;
@property (nonatomic, strong, nullable) NSString<Optional>* highway;
@property (nonatomic, strong, nullable) NSString<Optional>* routeContext;
@property (nonatomic, strong, nullable) NSMutableArray<MPRouteStep*><MPRouteStep, Optional>* steps;
@property (nonatomic, strong, nullable) MPTransitDetails<Optional>* transit_details;

- (nullable MPPoint*)getActionPoint;
- (nullable NSNumber*)getStartFloorName;
- (nullable MPPoint *)getStartPoint;
- (nullable MPPoint *)getEndPoint;

@end
