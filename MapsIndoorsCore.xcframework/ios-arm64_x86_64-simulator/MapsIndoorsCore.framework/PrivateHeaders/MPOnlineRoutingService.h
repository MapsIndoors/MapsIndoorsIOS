//
//  MPOnlineRoutingService.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 04/12/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import "MPRoutingServiceInterface.h"

@class MPPoint;
@protocol MPUserRole;

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPOnlineRoutingService : NSObject <MPRoutingServiceInterface>

+ (nullable NSString*) urlForFetchingRouteForSolutionId:(nonnull NSString*)solutionId
                                                graphId:(nonnull NSString*)graphId
                                                   from:(nonnull MPPoint *)from
                                                     to:(nonnull MPPoint *)to
                                             travelMode:(nonnull NSString*)travelMode
                                                  avoid:(nullable NSArray<NSString*>*)restrictions
                                          departureTime:(nullable NSDate*)departureTime
                                            arrivalTime:(nullable NSDate *)arrivalTime
                                              userRoles:(nullable NSArray<MPUserRole*>*)userRoles;

@end
