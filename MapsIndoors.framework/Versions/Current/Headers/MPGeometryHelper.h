//
//  MPGeometryHelper.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 15/09/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


@interface MPGeometryHelper : NSObject

+ (double) coordinateToLineDistance: (CLLocationCoordinate2D) coordinate toLineSegmentV: (CLLocationCoordinate2D) v andW: (CLLocationCoordinate2D) w;

@end
