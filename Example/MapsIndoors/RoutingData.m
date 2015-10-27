//
//  RoutingData.m
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 02/09/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import "RoutingData.h"
#import <HashBuilder/HashBuilder.h>

@implementation RoutingData {
    MPDirectionsService* _service;
}

- (void)routingFrom:(MPLocation *)from to:(MPLocation *)to by:(NSString *)mode avoid:(NSArray *)restrictions depart:(NSDate *)departureTime arrive:(NSDate *)arrivalTime {
    
    _service = [[MPDirectionsService alloc] initWithMapsIndoorsSolutionId:self.solutionId googleApiKey:self.googleApiKey];
    _service.delegate = self;
    
    self.origin = from;
    self.destination = to;
    
    HashBuilder *builder = [HashBuilder builder];
    
    [builder contributeObject:[[from getPoint] description]];
    [builder contributeObject:[[to getPoint] description]];
    [builder contributeObject:mode];
    [builder contributeObject:[restrictions componentsJoinedByString:@","]];
    
    self.destination = to;
    self.origin = from;
    [_service routingFrom:from to:to by:mode avoid:restrictions depart:departureTime arrive:arrivalTime];
    
    /*if (builder.builtHash != self.latestRoutingRequestHash) {
        //self.latestRoute = nil;
        self.destination = to;
        self.origin = from;
        [_service routingFrom:from to:to by:mode avoid:restrictions depart:departureTime arrive:arrivalTime];
        self.latestRoutingRequestHash = builder.builtHash;
    } else if (self.latestRoute) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RoutingDataReady" object: self.latestRoute];
    }*/
}

- (void)onRouteResultReady:(MPRoute *)route {
    self.latestRoute = route;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"RoutingDataReady" object: self.latestRoute];
}


@end
