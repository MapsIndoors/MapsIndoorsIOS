//
//  RouteResult.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 07/07/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import "MPJSONModel.h"
#import "MPRouteProperty.h"

@protocol MPRoute
@end

@interface MPRouteResult : MPJSONModel

@property (nonatomic, strong, nullable) NSArray<MPRoute, Optional>* routes;
@property (nonatomic, strong, nullable) NSString<Optional>* status;


@end
