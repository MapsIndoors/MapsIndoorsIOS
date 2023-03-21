//
//  MPRoute.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 8/9/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"
@import MapsIndoors;

@protocol MPEncodedPolylineInternal;
@protocol MPRouteBoundsInternal;
@protocol MPRouteLegInternal;

/// > Warning: [INTERNAL - DO NOT USE]

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 The route model contains the route components: The start and end point, the overall route distance, the duration using the given travel mode(s), the actual route components (legs and steps) containing the route geometry and actions (shifts, turns, climbs etc.) performed to get to the destination point. Typically this object is not manually instantiated, but returns as a result from the `MPDirectionsService`.
 */
@interface MPRouteInternal : JSONModel <MPRoute>

@property (nonatomic, copy, nullable) NSString* copyrights;
/**
 The route legs: the different route components. Typically a route from 1st floor to 2nd floor will consist of two route legs.
 */

- (void)addLeg:(nonnull id<MPRouteLeg>)leg;

@property (nonatomic, copy) NSArray<id<MPRouteLeg>><MPRouteLegInternal>* legs;
@property (nonatomic, strong, nullable) NSMutableArray<id<MPRouteLeg>><MPRouteLegInternal>* mutableLegs;

@property (nonatomic, strong, nullable) id<MPEncodedPolyline, MPEncodedPolylineInternal> overview_polyline;
/**
 Textual summary of the route.
 */
@property (nonatomic, copy, nullable) NSString* summary;
/**
 Textual warning for the route.
 */
@property (nonatomic, copy) NSArray* warnings;
/**
 The route bounds.
 */
@property (nonatomic, strong, nullable) id<MPRouteBounds, MPRouteBoundsInternal> bounds;
/**
 The full distance in meters.
 */
@property (nonatomic, strong) NSNumber* distance;
/**
 The full duration in seconds based on travel times for each leg/step.
 */
@property (nonatomic, strong) NSNumber* duration;
/**
 The restrictions that apply for the route. May be empty/nil
 */
@property (nonatomic, copy) NSArray<NSString*>* restrictions;

/**
 Find route segment path (route leg and route step) nearest to a point and floor index.
 */
- (MPRouteSegmentPath*)findNearestRouteSegmentPathFromPoint:(nonnull MPPoint*)point floorIndex:(nonnull NSNumber*)floorIndex;

@end

NS_ASSUME_NONNULL_END
