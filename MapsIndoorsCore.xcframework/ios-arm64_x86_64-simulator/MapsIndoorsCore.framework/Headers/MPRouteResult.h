//
//  RouteResult.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 07/07/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"
#import "MPRouteProperty.h"
#import "MPRoute.h"

@protocol MPRoute
@end

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Route result model
 */
@interface MPRouteResult : JSONModel

/**
 Routes in the result.
 */
@property (nonatomic, strong, nonnull, readonly) NSArray<MPRoute*>* routes;
/**
 Status code from the directions service. "OK" means that a route was successfully returned.
 */
@property (nonatomic, strong, nullable, readonly) NSString* status;


@end
