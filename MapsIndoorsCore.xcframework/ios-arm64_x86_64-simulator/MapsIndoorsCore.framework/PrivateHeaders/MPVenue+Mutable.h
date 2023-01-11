//
//  MPVenue+Mutable.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 23/08/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import "MPVenue.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPVenue ()

@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* solutionId;
@property (nonatomic, strong, nullable, readwrite) NSString* venueId;
@property (nonatomic, strong, nullable, readwrite) NSNumber<Optional>* defaultFloor;
@property (nonatomic, strong, nullable, readwrite) NSString* tilesUrl;
@property (nonatomic, strong, nullable, readwrite) NSArray<MPBuilding*><MPBuilding, Optional>* buildings;
@property (nonatomic, strong, nullable, readwrite) MPPoint<Optional>* anchor;
@property (nonatomic, strong, nullable, readwrite) NSArray<Optional>* bbox;
@property (nonatomic, strong, nullable, readwrite) NSArray<NSArray*>* bounds;
@property (nonatomic, strong, nullable, readwrite) NSArray<MPPoint*><Optional, MPPoint>* entryPoints;
@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* graphId;
@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* administrativeId;
@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* externalId;
@property (nonatomic, strong, nullable, readwrite) NSString<Optional>* name;
@property (nonatomic, strong, nullable, readwrite) NSArray<MPMapStyle*><MPMapStyle>* styles;
@property (nonatomic, strong, nullable, readwrite) NSDictionary<NSString*, MPLocationField*><Optional, MPLocationField> *properties;

@end

NS_ASSUME_NONNULL_END
