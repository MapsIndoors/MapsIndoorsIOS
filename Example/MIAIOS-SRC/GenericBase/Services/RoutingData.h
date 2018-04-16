//
//  RoutingData.h
//  MIAIOS
//
//  Created by Daniel Nielsen on 02/09/15.
//  Copyright (c) 2015-2018 MapsPeople A/S. All rights reserved.
//

#import <MapsIndoors/MapsIndoors.h>

@interface RoutingData : MPDirectionsService

@property (nonatomic)         NSUInteger    latestRoutingRequestHash;
@property (nonatomic, strong) MPRoute*      latestRoute;
@property (nonatomic, strong) NSArray*      latestModelArray;
@property (nonatomic, strong) NSString*     travelMode;
@property (nonatomic, strong) MPLocation*   origin;
@property (nonatomic, strong) MPLocation*   destination;

- (void)routingFrom:(MPLocation *)from to:(MPLocation *)to by:(NSString *)mode avoid:(NSArray *)restrictions depart:(NSDate *)departureTime arrive:(NSDate *)arrivalTime;

@end
