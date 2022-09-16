//
//  RouteResult.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 07/07/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"
#import "MPRouteProperty.h"

@protocol MPRoute
@end

/**
 Route result model
 */
@interface MPRouteResult : JSONModel

/**
 Routes in the result.
 */
@property (nonatomic, strong, nullable) NSArray<MPRoute, Optional>* routes;
/**
 Status code from the directions service. "OK" means that a route was successfully returned.
 */
@property (nonatomic, strong, nullable) NSString<Optional>* status;


@end
