//
//  GoogleMaps+MapsPeople.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 31/05/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <GoogleMaps/GoogleMaps.h>

//
//  Various helper functions for Google Maps classes.
//

@interface GMSCoordinateBounds (MapsPeople)

/**
 @return Area in m2 covered by coordinate bounds
 */
- (double) mp_area;

/**
 Compute intersection of this GMSCoordinateBounds with 'other'-

 @param other GMSCoordinateBounds
 @return GMSCoordinateBounds, nil if no intersection.
 */
- (GMSCoordinateBounds*) mp_intersectWith:(GMSCoordinateBounds*)other;

@end
