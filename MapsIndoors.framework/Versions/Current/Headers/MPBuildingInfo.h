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

@property NSString* name;
@property NSArray<NSString*>* aliases;

@end
