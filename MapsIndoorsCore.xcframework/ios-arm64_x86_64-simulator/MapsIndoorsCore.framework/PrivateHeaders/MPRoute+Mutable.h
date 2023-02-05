//
//  MPRoute+Private.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 19/08/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import "MPRoute.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPRoute ()

@property (nonatomic, strong, nullable, readwrite) NSString* copyrights;
@property (nonatomic, strong, nullable, readwrite) NSMutableArray<MPRouteLeg*><MPRouteLeg>* mutableLegs;
@property (nonatomic, strong, nullable, readwrite) MPEncodedPolyline* overview_polyline;
@property (nonatomic, strong, nullable, readwrite) NSString* summary;
@property (nonatomic, strong, nullable, readwrite) NSArray* warnings;
@property (nonatomic, strong, nullable, readwrite) MPRouteBounds* bounds;
@property (nonatomic, strong, nullable, readwrite) NSNumber* distance;
@property (nonatomic, strong, nullable, readwrite) NSNumber* duration;
@property (nonatomic, strong, nullable, readwrite) NSArray<NSString*>* restrictions;

@end

NS_ASSUME_NONNULL_END
