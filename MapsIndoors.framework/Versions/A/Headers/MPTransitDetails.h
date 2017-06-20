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

@interface MPTransitDetails : JSONModel

//Line contains information about the transit line used in this step, and may include the the following properties:
@property MPTransitLine<Optional>* line;
//arrival_stop contains information about the stop/station for this part of the trip.
@property MPTransitStop<Optional>* arrival_stop;
//arrival_stop contains information about the stop/station for this part of the trip.
@property MPTransitStop<Optional>* departure_stop;
//Contains the arrival times for this leg of the journey.
@property MPTransitTime<Optional>* arrival_time;
//Contains the departure times for this leg of the journey.
@property MPTransitTime<Optional>* departure_time;
//Headsign specifies the direction in which to travel on this line, as it is marked on the vehicle or at the departure stop. This will often be the terminus station.
@property NSString<Optional>* headsign;
//Specifies the expected number of seconds between departures from the same stop at this time. For example, with a headway value of 600, you would expect a ten minute wait if you should miss your bus.
@property NSNumber<Optional>* headway;
//num_stops contains the number of stops in this step, counting the arrival stop, but not the departure stop. For example, if your directions involve leaving from Stop A, passing through stops B and C, and arriving at stop D, num_stops will return 3.
@property NSNumber<Optional>* num_stops;

@end
