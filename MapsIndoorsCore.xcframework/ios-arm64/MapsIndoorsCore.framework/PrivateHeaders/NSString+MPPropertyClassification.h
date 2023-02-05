//
//  NSString+MPPropertyClassification.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 27/11/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(unsigned char, MPBarrierType) {
    MPBarrierType_Normal,
    MPBarrierType_Door,
    MPBarrierType_ElevatorDoor,
};

typedef NS_ENUM(unsigned char, MPBoundaryType) {
    MPBoundaryType_Normal               = 0,    // Not an entrypoint
    MPBoundaryType_EntryPoint           = 1,    // Entry point for all travelmodes; no additional bits need to be set.
    MPBoundaryType_EntryPointWalking    = 2,    // Bit for Walking entry points
    MPBoundaryType_EntryPointDriving    = 4,    // Bit for driving entry points
    MPBoundaryType_EntryPointBicycling  = 8,    // Bit for Bike entry points
    MPBoundaryType_EntryPointTransit    = 16,   // Bit for Transit entry points
};

BOOL  mp_boundaryIsEntryPoint( MPBoundaryType boundaryType );

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface NSString (MPPropertyClassification)

- (MPBarrierType) as_MPBarrierType;
- (MPBoundaryType) as_MPBoundaryType;

@end
