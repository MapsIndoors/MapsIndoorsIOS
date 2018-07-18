//
//  MPRouteInstructions.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 11/14/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import "MPJSONModel.h"

__attribute__((deprecated))
@interface MPRouteInstructions : MPJSONModel

@property (nonatomic, strong, nullable) NSArray* indications;
@property (nonatomic, strong, nullable) NSArray* descriptions;
@property (nonatomic, strong, nullable) NSArray* distances;

- (nullable NSArray*)getDirectionChanges;

@end
