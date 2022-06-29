//
//  MPPolyline.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 07/07/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//
@import JSONModel;

@interface MPEncodedPolyline : JSONModel

@property (nonatomic, strong, nullable) NSString* points;

@end
