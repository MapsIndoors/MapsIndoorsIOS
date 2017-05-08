//
//  MPSite.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 8/16/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import <JSONModel/JSONModel.h>

/**
 * Site / app class. Holds a basic identifier.
 */
@interface MPSite : JSONModel

/**
 * Site name / identifier.
 */
@property NSString* name;

@end
