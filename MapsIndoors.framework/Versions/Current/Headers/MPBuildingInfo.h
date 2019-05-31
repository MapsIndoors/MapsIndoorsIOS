//
//  BuildingInfo.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 21/10/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPJSONModel.h"

@interface MPBuildingInfo : MPJSONModel

@property (nonatomic, strong, nullable) NSString* name;
@property (nonatomic, strong, nullable) NSArray<NSString*>* aliases;

@end
