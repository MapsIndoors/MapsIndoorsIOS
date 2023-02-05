//
//  MPDefines.h
//  MapsIndoorsSDK
//
//  Created by Michael Bech Hansen on 08/03/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
#ifndef MPDefines_h
#define MPDefines_h


#if defined(MP_DISABLE_DEPRECATION_WARNINGS)
    #define MP_DEPRECATED_MSG_ATTRIBUTE(mESSAGE)    /* disabled */
    #define MP_DEPRECATED_ATTRIBUTE                 /* disabled */
#else
    #define MP_DEPRECATED_MSG_ATTRIBUTE(mESSAGE)    DEPRECATED_MSG_ATTRIBUTE(mESSAGE)
    #define MP_DEPRECATED_ATTRIBUTE                 DEPRECATED_ATTRIBUTE
#endif

#define kMPUIApplicationDidReceiveMemoryWarningNotification @"UIApplicationDidReceiveMemoryWarningNotification"
#define kMPRequestClearCacheMemoryNotification @"MPRequestClearCacheMemoryNotification"
#define kMPRequestResetMapNotification @"MPRequestResetMapNotification"

#endif /* MPDefines_h */

// Modification of this enum should be followed by similar modifications in the relevant if-else chains.
/// An enumeration of all accepted types of highways.
typedef NSString* MPHighwayType NS_TYPED_ENUM;
extern MPHighwayType const MPHighwayTypeUnclassified;
extern MPHighwayType const MPHighwayTypeFootway;
extern MPHighwayType const MPHighwayTypeResidential;
extern MPHighwayType const MPHighwayTypeService;
extern MPHighwayType const MPHighwayTypeRamp;
extern MPHighwayType const MPHighwayTypeStairs;
extern MPHighwayType const MPHighwayTypeEscalator;
extern MPHighwayType const MPHighwayTypeTravelator;
extern MPHighwayType const MPHighwayTypeElevator;
extern MPHighwayType const MPHighwayTypeWheelChairRamp;
extern MPHighwayType const MPHighwayTypeWheelChairLift;
extern MPHighwayType const MPHighwayTypeLadder;
