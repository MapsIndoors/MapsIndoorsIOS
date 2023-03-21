//
//  MPPolyline.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 07/07/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"
@import MapsIndoors;

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPEncodedPolylineInternal : JSONModel <MPEncodedPolyline>

@property (nonatomic, copy, nullable) NSString* points;

@end
