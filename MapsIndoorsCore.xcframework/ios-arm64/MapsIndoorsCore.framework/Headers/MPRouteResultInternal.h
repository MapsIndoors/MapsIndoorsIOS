//
//  RouteResult.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 07/07/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"
@import MapsIndoors;

@protocol MPRouteInternal;

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Route result model
 */
@interface MPRouteResultInternal : JSONModel <MPRouteResult>

/**
 Routes in the result.
 */
@property (nonatomic, copy, nonnull) NSArray<id<MPRoute>><MPRouteInternal>* routes;
/**
 Status code from the directions service. "OK" means that a route was successfully returned.
 */
@property (nonatomic, copy, nullable) NSString* status;

@end
