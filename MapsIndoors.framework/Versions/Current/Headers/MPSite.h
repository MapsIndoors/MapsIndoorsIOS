//
//  MPSite.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 8/16/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import "MPJSONModel.h"

/**
 Site / app class. Holds a basic identifier.
 */
@interface MPSite : MPJSONModel

/**
 Site name / identifier.
 */
@property NSString* name;

@end
