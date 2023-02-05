//
//  MPRouteStep+Mutable.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 25/08/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import "MPRouteStep.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPRouteStep ()

@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* travel_mode;
@property (nonatomic, strong, nullable, readwrite) MPRouteCoordinate<Optional>* end_location;
@property (nonatomic, strong, nullable, readwrite) MPRouteCoordinate<Optional>* start_location;
@property (nonatomic, strong, nullable, readwrite) NSNumber<Optional>* distance;
@property (nonatomic, strong, nullable, readwrite) NSNumber<Optional>* duration;
@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* maneuver;
@property (nonatomic, strong, nullable, readwrite) MPEncodedPolyline<Optional>* polyline;
@property (nonatomic, strong, nullable, readwrite) NSMutableArray<MPRouteCoordinate*><MPRouteCoordinate,Optional>* mutableGeometry;
@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* html_instructions;
@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* highway;
@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* routeContext;
@property (nonatomic, strong, nullable, readwrite) NSMutableArray<MPRouteStep*><MPRouteStep, Optional>* mutableSteps;
@property (nonatomic, strong, nullable, readwrite) MPTransitDetails<Optional>* transit_details;

@end

NS_ASSUME_NONNULL_END
