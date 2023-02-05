//
//  MPTransitDetails.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 24/11/2016.
//  Copyright  Daniel-Nielsen. All rights reserved.
//

#import "JSONModel.h"
#import "MPTransitStop.h"
#import "MPTransitLine.h"
#import "MPRouteProperty.h"
#import "MPTransitTime.h"

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Transit details information.
 */
@interface MPTransitDetails : JSONModel

/**
 Line contains information about the transit line used in this step.
 */
@property (nonatomic, strong, nullable, readonly) MPTransitLine<Optional>* line;

/**
 Arrival stop contains information about the arrival stop/station for this part of the trip.
 */
@property (nonatomic, strong, nullable, readonly) MPTransitStop<Optional>* arrival_stop;

/**
 Departure stop contains information about the departure stop/station for this part of the trip.
 */
@property (nonatomic, strong, nullable, readonly) MPTransitStop<Optional>* departure_stop;

/**
 Contains the arrival times for this leg of the journey.
 */
@property (nonatomic, strong, nullable, readonly) MPTransitTime<Optional>* arrival_time;

/**
 Contains the departure times for this leg of the journey.
 */
@property (nonatomic, strong, nullable, readonly) MPTransitTime<Optional>* departure_time;

/**
 Headsign specifies the direction in which to travel on this line, as it is marked on the vehicle or at the departure stop. This will often be the terminus station.
 */
@property (nonatomic, strong, nullable, readonly) NSString<Optional>* headsign;

/**
 Specifies the expected number of seconds between departures from the same stop at this time. For example, with a headway value of 600, you would expect a ten minute wait if you should miss your bus.
 */
@property (nonatomic, strong, nullable, readonly) NSNumber<Optional>* headway;

/**
 Number of stops. Contains the number of stops in this step, counting the arrival stop, but not the departure stop. For example, if your directions involve leaving from Stop A, passing through stops B and C, and arriving at stop D, num_stops will return 3.
 */
@property (nonatomic, strong, nullable, readonly) NSNumber<Optional>* num_stops;

@end
