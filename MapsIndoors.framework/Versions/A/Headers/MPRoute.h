//
//  MPRoute.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 8/9/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import <GoogleMaps/GoogleMaps.h>
#import "MPEncodedPolyline.h"
#import "MPRouteProperty.h"
#import "MPRouteCoordinate.h"
#import "MPRouteBounds.h"

/**
 * Protocol MPRouteLeg specification.
 */
@protocol MPRouteLeg
@end

/**
 * Routing is under development. The route model contains the route components: The start and end point, the overall route distance, the duration using the chosen vehicle(s), the actual route components (routeLegs) containing the route geometry and actions (shifts, turns, climbs etc.) performed to get to the destination point. Typically this object is not manually instantiated, but returns as a result from a routing provider (MPRoutingProvider).
 */
@interface MPRoute : JSONModel

@property NSString<Optional>* copyrights;
/**
 * The route legs: the different route components. Typically a route from 1st floor to 2nd floor will consist of two route legs.
 */
@property NSMutableArray<MPRouteLeg, Optional>* legs;
@property MPEncodedPolyline<Optional>* overview_polyline;
@property NSString<Optional>* summary;
@property NSArray<Optional>* warnings;
@property MPRouteBounds<Optional>* bounds;

//---
//--- Extra properties; NOT part of the JSON result from the server
//---
@property (nonatomic) NSNumber<Optional>* distance;
@property (nonatomic) NSNumber<Optional>* duration;
@property NSArray<Optional>* restrictions;
@property NSString<Optional>* venue;

/**
 * The route geometry as Google Maps polylines.
 */
@property NSMutableArray<Optional>* polylines;
/**
 * The route geometry as Google Maps polylines (line stroke imitation).
 */
@property NSMutableArray<Optional>* polylineStrokes;
/**
 * The map on which to draw the route.
 */
@property GMSMapView<Optional>* map;

/**
 * Draw the route on the map.
 */
- (void)addToMap:(GMSMapView*)map highlightFloor:(int)floorIndex;
/**
 * Clear the route on the map.
 */
- (void)clearRouteDraw;
/**
 * Make the route fully visible on the map.
 */
- (void)showAll;

@end
