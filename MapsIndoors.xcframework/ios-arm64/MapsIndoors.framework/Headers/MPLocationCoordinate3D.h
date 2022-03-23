//
//  MPLocationCoordinate3D.h
//  MapsIndoorsSDK
//
//  Created by Michael Bech Hansen on 27/11/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#ifndef MPLocationCoordinate3D_h
#define MPLocationCoordinate3D_h

#import <CoreLocation/CoreLocation.h>       // CLLocationCoordinate2D


/**
 A structure that contains a coordinate in 3D space: latitude/longitude and floor.
 
 Fields:
   latLng:
     The geographical location (latitude/longitude( in degrees.
   floorId:
     The id of the floor.  Additional information about the floor can be found in the solution/building data.
 */
struct MPLocationCoordinate3D {
    CLLocationCoordinate2D      latLng;
    NSInteger                   floorId;
};
typedef struct MPLocationCoordinate3D MPLocationCoordinate3D;


static inline MPLocationCoordinate3D  MPLocationCoordinate3DMake( double lat, double lng, NSInteger floorId ) {
    
    MPLocationCoordinate3D c3d;
    c3d.latLng = CLLocationCoordinate2DMake(lat, lng);
    c3d.floorId = floorId;
    return c3d;
}

static inline BOOL MPLocationCoordinate3DIsEqual( MPLocationCoordinate3D a, MPLocationCoordinate3D b ) {
    
    return (a.latLng.latitude == b.latLng.latitude) && (a.latLng.longitude == b.latLng.longitude) && (a.floorId == b.floorId);
}

#define MPLocationCoordinate3DNull      MPLocationCoordinate3DMake(0,0,0)

#endif /* MPLocationCoordinate3D_h */
