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
@interface MPTransitDetails()

@property (nonatomic, strong, nullable, readwrite) MPTransitLine<Optional>* line;
@property (nonatomic, strong, nullable, readwrite) MPTransitStop<Optional>* arrival_stop;
@property (nonatomic, strong, nullable, readwrite) MPTransitStop<Optional>* departure_stop;
@property (nonatomic, strong, nullable, readwrite) MPTransitTime<Optional>* arrival_time;
@property (nonatomic, strong, nullable, readwrite) MPTransitTime<Optional>* departure_time;
@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* headsign;
@property (nonatomic, strong, nullable, readwrite) NSNumber<Optional>* headway;
@property (nonatomic, strong, nullable, readwrite) NSNumber<Optional>* num_stops;

@end
