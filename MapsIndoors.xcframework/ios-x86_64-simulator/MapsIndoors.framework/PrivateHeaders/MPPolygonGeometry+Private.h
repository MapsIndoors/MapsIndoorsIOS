//
//  MPPolygonGeometry+Private.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 09/05/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "MPPolygonGeometry.h"

@class MIPolygon;

@interface MPPolygonGeometry (Private)

- (instancetype _Nullable )initWithCoordinates: (NSArray<NSArray<NSNumber*>*>* _Nonnull) coordinates;

@property (nonatomic, strong, readonly, nullable) NSArray<GMSPath*><Optional>*  gmspaths;       // gmspath is computed and therefore not present in JSON, so mark Optional

- (instancetype _Nullable ) initWithDictionary:(NSDictionary *_Nonnull)dict error:(NSError * _Nonnull __autoreleasing *_Nullable)err;

@property (nonatomic, strong, readonly, nonnull) MIPolygon* miPolygon;

@end
