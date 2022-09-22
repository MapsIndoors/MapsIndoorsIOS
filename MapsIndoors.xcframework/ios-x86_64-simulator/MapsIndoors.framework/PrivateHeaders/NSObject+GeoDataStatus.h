//
//  NSObject+GeoDataStatus.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 28/10/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_OPTIONS( NSUInteger, MPGeoDataStatus )
{
    MPGeoDataStatusActive = 1 << 0,
    MPGeoDataStatusSearchable = 1 << 1
};


@interface NSObject (GeoDataStatus)

@property (nonatomic, setter=mp_setGeoDataStatus:) MPGeoDataStatus      mp_geoDataStatus;
- (BOOL) mp_isActive;
- (BOOL) mp_isSearchable;

- (void) mp_updateGeoDataStatusFromDict:(NSDictionary*)dict;

@end
