//
//  MPMultiPolygonGeometry.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 14/09/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "MPGeometry.h"
#import "MPGeometryQueryProtocol.h"


@class MPPolygonGeometry;


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPMultiPolygonGeometry : MPGeometry <MPGeometryQueryProtocol>

@property (nonatomic, strong, readonly) NSArray<MPPolygonGeometry*>*    polygons;

@end

