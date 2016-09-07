//
//  RoutingData.h
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 02/09/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import <MapsIndoors/MapsIndoors.h>

@interface RoutingData : MPDirectionsService<MPRoutingProviderDelegate>

@property NSUInteger latestRoutingRequestHash;
@property MPRoute* latestRoute;
@property MPLocation* origin;
@property MPLocation* destination;

- (void)routingFrom:(MPLocation *)from to:(MPLocation *)to by:(NSString *)mode avoid:(NSArray *)restrictions depart:(NSDate *)departureTime arrive:(NSDate *)arrivalTime;

@end
