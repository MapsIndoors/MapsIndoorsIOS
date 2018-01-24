//
//  PointXY.m
//  MapsIndoors
//
//  Created by Martin Hansen on 5/21/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import "PointXY.h"

//Sets an arbitrary reference point at the first given beacon
//ANY reference position could be used - but using a ref point close to the measurement point yields better accuracy.
static CLLocationCoordinate2D refPoint;
static bool isRefSet = NO;

@implementation PointXY

//Adds new measurement points( <lat,long> and distance to that point )
- (void) PointXY: (CLLocationCoordinate2D)coord  dist:(double)dist {
    if ( isRefSet == NO ) {
        refPoint = CLLocationCoordinate2DMake(coord.latitude,coord.longitude);
        isRefSet = YES;
    }
    double xdist = refPoint.latitude - self.X;
    double ydist = refPoint.longitude - self.Y;
    double refDist = sqrt((xdist*xdist)+(ydist*ydist));
    double refBearing = M_PI_2 - atan2(ydist, xdist);
    self.X = cos(refBearing) * refDist;
    self.Y = sin(refBearing) * refDist;
    self.latlng = coord;
    self.distance = dist;
}

+ (CLLocationCoordinate2D) getRefPoint {
    return refPoint;
}

@end
