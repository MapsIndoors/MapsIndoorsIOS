//
//  MPBeaconCollection.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 26/02/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import "MPBeacon.h"


@interface MPBeaconCollection : MPJSONModel

@property (nonatomic, strong, nullable) NSArray<MPBeacon*><MPBeacon>* list;

@end
