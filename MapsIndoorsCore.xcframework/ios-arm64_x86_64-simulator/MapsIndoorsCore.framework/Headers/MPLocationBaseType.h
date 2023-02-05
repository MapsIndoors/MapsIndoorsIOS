//
//  MPLocationBaseType.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 21/08/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
#ifndef MPLocationBaseType_h
#define MPLocationBaseType_h

typedef NS_ENUM(NSUInteger, MPLocationBaseType) {
    MPLocationBaseTypeVenue = 5,
    MPLocationBaseTypeBuilding = 4,
    MPLocationBaseTypeFloor = 3,
    MPLocationBaseTypeRoom = 2,
    MPLocationBaseTypeArea = 1,
    MPLocationBaseTypePointOfInterest = 0,
};

#endif /* MPLocationBaseType_h */
