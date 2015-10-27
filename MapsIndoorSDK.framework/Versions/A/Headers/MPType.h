//
//  MPType.h
//  MapsIndoorSDK for iOS
//
//  Created by Martin Hansen on 7/23/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"

/**
 * POI types (used by MapsPeoples services)
 */
@interface MPType : JSONModel

@property NSString* name;
@property NSString* icon;

@end
