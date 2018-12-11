//
//  MPRoute.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 8/9/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import "MPJSONModel.h"
#import <GoogleMaps/GoogleMaps.h>
#import "MPEncodedPolyline.h"
#import "MPRouteProperty.h"
#import "MPRouteCoordinate.h"
#import "MPRouteBounds.h"
#import "MPPoint.h"
#import "MPRouteLeg.h"

struct MPRouteSegmentPath {
    NSInteger legIndex;
    NSInteger stepIndex;
};
typedef struct MPRouteSegmentPath MPRouteSegmentPath;

/**
 Protocol MPRouteLeg specification.
 */
@protocol MPRouteLeg
@end

/**
 Routing is under development. The route model contains the route components: The start and end point, the overall route distance, the duration using the chosen vehicle(s), the actual route components (routeLegs) containing the route geometry and actions (shifts, turns, climbs etc.) performed to get to the destination point. Typically this object is not manually instantiated, but returns as a result from a routing provider (MPRoutingProvider).
 */
@interface MPRoute : MPJSONModel

@property (nonatomic, strong, nullable) NSString<Optional>* copyrights;
/**
 The route legs: the different route components. Typically a route from 1st floor to 2nd floor will consist of two route legs.
 */
@property (nonatomic, strong, nullable) NSMutableArray<MPRouteLeg*><MPRouteLeg,Optional>* legs;
@property (nonatomic, strong, nullable) MPEncodedPolyline<Optional>* overview_polyline;
@property (nonatomic, strong, nullable) NSString<Optional>* summary;
@property (nonatomic, strong, nullable) NSArray<Optional>* warnings;
@property (nonatomic, strong, nullable) MPRouteBounds<Optional>* bounds;
@property (nonatomic, strong, nullable) NSNumber<Optional>* distance;
@property (nonatomic, strong, nullable) NSNumber<Optional>* duration;
@property (nonatomic, strong, nullable) NSArray<NSString*><Optional>* restrictions;


/**
 Find route segment path (route leg and route step) nearest to a point and floor index.
 */
- (MPRouteSegmentPath)findNearestRouteSegmentPathFromPoint:(nonnull MPPoint*)point floor: (nonnull NSNumber*) floorIndex;
@end
