//
//  MPGeometryContainmentMetadata.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 31/05/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPGeometryContainmentMetadata : NSObject

@property (nonatomic, strong) NSObject*         geoSpatialObject;       // For now only MPLocation can be here.
@property (nonatomic) BOOL                      isContained;            // Inside polygon and not in a hole.
@property (nonatomic) BOOL                      isContainedInHole;      // Inside a polygon hole
@property (nonatomic) CLLocationCoordinate2D    coordinate;             // If isContained actual coordinate, if not contained nearest coordinate on boundary.
@property (nonatomic) CLLocationDistance        distance;               // 0 if contained, else distance to closest point.

+ (instancetype) newWithGeoSpatialObject:(NSObject*)gso;
- (instancetype) initWithGeoSpatialObject:(NSObject*)gso;

@end
