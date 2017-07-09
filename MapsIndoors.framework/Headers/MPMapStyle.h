//
//  MPMapStyle.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 1/13/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import "MPJSONModel.h"

/**
 Map style (used by MapsPeoples services)
 */
@interface MPMapStyle : MPJSONModel

@property NSString* folder;
@property NSString* displayName;

@end
