//
//  MPRouteLeg+Private.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 20/08/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import "MPRouteLeg.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPRouteLeg ()

@property (nonatomic, strong, nullable, readwrite) NSNumber<Optional>* distance;
@property (nonatomic, strong, nullable, readwrite) NSNumber<Optional>* duration;
@property (nonatomic, strong, nullable, readwrite) MPRouteCoordinate<Optional>* start_location;
@property (nonatomic, strong, nullable, readwrite) MPRouteCoordinate<Optional>* end_location;
@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* start_address;
@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* end_address;
@property (nonatomic, strong, nullable, readwrite) NSMutableArray<MPRouteStep*><MPRouteStep, Optional>* mutableSteps;
@property (nonatomic, readwrite) MPRouteLegType        routeLegType;

@end

NS_ASSUME_NONNULL_END
