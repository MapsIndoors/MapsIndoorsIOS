//
//  MPRouteNetworkEntryPoint.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 01/05/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <MapsIndoors/MapsIndoors.h>
#import "NSString+MPPropertyClassification.h"


NS_ASSUME_NONNULL_BEGIN


@class MPGraphNode;


@interface MPRouteNetworkEntryPoint : MPPoint

@property (nonatomic) MPBoundaryType    boundaryType;
@property (nonatomic) NSString*         label;

+ (nullable instancetype) newWithEntryPointNode:(MPGraphNode*)entryPointNode;
- (nullable instancetype) initWithEntryPointNode:(MPGraphNode *)entryPointNode;

@end


NS_ASSUME_NONNULL_END
