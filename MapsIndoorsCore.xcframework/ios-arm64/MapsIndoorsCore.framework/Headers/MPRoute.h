//
//  MPRoute.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 8/9/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"

#import "MPEncodedPolyline.h"
#import "MPRouteProperty.h"
#import "MPRouteCoordinate.h"
#import "MPRouteBounds.h"
#import "MPPoint.h"
#import "MPRouteLeg.h"


/**
 Route segment path model
 */
struct MPRouteSegmentPath {
    /**
     Leg index
     */
    NSInteger legIndex;
    /**
     Step index
     */
    NSInteger stepIndex;
};
typedef struct MPRouteSegmentPath MPRouteSegmentPath;

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Protocol MPRouteLeg specification.
 */
@protocol MPRouteLeg
@end

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 The route model contains the route components: The start and end point, the overall route distance, the duration using the given travel mode(s), the actual route components (legs and steps) containing the route geometry and actions (shifts, turns, climbs etc.) performed to get to the destination point. Typically this object is not manually instantiated, but returns as a result from the `MPDirectionsService`.
 */
@interface MPRoute : JSONModel

@property (nonatomic, strong, nullable, readonly) NSString* copyrights;
/**
 The route legs: the different route components. Typically a route from 1st floor to 2nd floor will consist of two route legs.
 */
@property (nonatomic, strong, readonly) NSArray<MPRouteLeg*>* legs;

@property (nonatomic, strong, nullable, readonly) MPEncodedPolyline* overview_polyline;
/**
 Textual summary of the route.
 */
@property (nonatomic, strong, nullable, readonly) NSString* summary;
/**
 Textual warning for the route.
 */
@property (nonatomic, strong, readonly) NSArray* warnings;
/**
 The route bounds.
 */
@property (nonatomic, strong, nullable, readonly) MPRouteBounds* bounds;
/**
 The full distance in meters.
 */
@property (nonatomic, strong, readonly) NSNumber* distance;
/**
 The full duration in seconds based on travel times for each leg/step.
 */
@property (nonatomic, strong, readonly) NSNumber* duration;
/**
 The restrictions that apply for the route. May be empty/nil
 */
@property (nonatomic, strong, readonly) NSArray<NSString*>* restrictions;

/**
 Find route segment path (route leg and route step) nearest to a point and floor index.
 */
- (MPRouteSegmentPath)findNearestRouteSegmentPathFromPoint:(nonnull MPPoint*)point floorIndex:(nonnull NSNumber*)floorIndex;
@end

NS_ASSUME_NONNULL_END
