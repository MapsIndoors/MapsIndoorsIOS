//
//  MPConstants.h
//  MapsIndoorsSDK
//
//  Created by Michael Bech Hansen on 22/09/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#ifndef MPConstants_h
#define MPConstants_h

#import <Foundation/Foundation.h>

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
typedef NS_ENUM(SInt32, MapOverlayZIndex) {
    MapOverlayZIndexStartMapsIndoorOverlays   = 1000000,

    MapOverlayZIndexStartPolygonsRange        = 1000000,
    MapOverlayZIndexEndPolygonsRange          = 1199999,
    
    MapOverlayZIndexStartModel2DRange         = 1200000,
    MapOverlayZIndexEndModel2DRange           = 1499999,
    
    MapOverlayZIndexBuildingOutlineHighlight  = 1300000,
    MapOverlayZIndexLocationOutlineHighlight  = 1300010,
    MapOverlayZIndexDirectionsOverlays        = 1300020,
    MapOverlayZIndexPositioningAccuracyCircle = 1300030,
    MapOverlayZIndexUserLocationMarker        = 1300040,

    MapOverlayZIndexEndMapsIndoorOverlays     = 1499999,
};


#endif /* MPConstants_h */
