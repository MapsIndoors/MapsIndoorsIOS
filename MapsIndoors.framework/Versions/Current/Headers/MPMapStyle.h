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

@property (nonatomic, strong, nullable) NSString* folder;
@property (nonatomic, strong, nullable) NSString* displayName;

@end
