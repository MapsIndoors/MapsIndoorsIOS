//
//  BuildingInfo.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 21/10/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPBuildingInfo : JSONModel

@property (nonatomic, strong, nullable) NSString* name;
@property (nonatomic, strong, nullable) NSArray<NSString*>* aliases;

@end
