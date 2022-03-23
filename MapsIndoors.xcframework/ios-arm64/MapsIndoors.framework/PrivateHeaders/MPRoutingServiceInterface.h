//
//  MPRoutingServiceInterface.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 04/12/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@class MPUserRole;


NS_ASSUME_NONNULL_BEGIN


@class MPRoute;
typedef void(^MPRoutingServiceHandlerBlockType)(MPRoute* _Nullable route, NSError* _Nullable error);


@protocol MPRoutingServiceInterface <NSObject>

- (void) getRouteForSolutionId:(NSString*)solutionId
                       graphId:(NSString*)graphId
                          from:(CLLocationCoordinate2D)from
                     fromFloor:(int)fromFloor
                            to:(CLLocationCoordinate2D)to
                       toFloor:(int)toFloor
                    travelMode:(NSString*)travelMode
                         avoid:(nullable NSArray<NSString*>*)restrictions
                 departureTime:(nullable NSDate*)departureTime
                   arrivalTime:(nullable NSDate *)arrivalTime
                     userRoles:(nullable NSArray<MPUserRole*>*)userRoles
             completionHandler:(MPRoutingServiceHandlerBlockType)completion;

@end


NS_ASSUME_NONNULL_END
