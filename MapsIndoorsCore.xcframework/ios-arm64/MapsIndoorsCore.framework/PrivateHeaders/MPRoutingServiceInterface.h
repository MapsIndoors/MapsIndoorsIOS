//
//  MPRoutingServiceInterface.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 04/12/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

@import CoreLocation;
@import Foundation;
@import MapsIndoors;

NS_ASSUME_NONNULL_BEGIN

@class MPRouteInternal;

typedef void(^MPRoutingServiceHandlerBlockType)(MPRouteInternal* _Nullable route, NSError* _Nullable error);


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@protocol MPRoutingServiceInterface <NSObject>

- (void) getRouteForSolutionId:(NSString*)solutionId
                       graphId:(NSString*)graphId
                          from:(CLLocationCoordinate2D)from
                     fromFloor:(NSInteger)fromFloor
                            to:(CLLocationCoordinate2D)to
                       toFloor:(NSInteger)toFloor
                    travelMode:(NSString*)travelMode
                         avoid:(nullable NSArray<MPHighway*>*)restrictions
                 departureTime:(nullable NSDate*)departureTime
                   arrivalTime:(nullable NSDate *)arrivalTime
                     userRoles:(nullable NSArray<MPUserRole*>*)userRoles
             completionHandler:(MPRoutingServiceHandlerBlockType)completion;

@end

NS_ASSUME_NONNULL_END
