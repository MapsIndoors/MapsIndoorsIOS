//
//  MPRouteInstructions.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 11/14/13.
//  Copyright (c) 2013 MapsPeople A/S. All rights reserved.
//

@import JSONModel;

__attribute__((deprecated))
@interface MPRouteInstructions : JSONModel

@property NSArray* indications;
@property NSArray* descriptions;
@property NSArray* distances;

- (NSArray*)getDirectionChanges;

@end
