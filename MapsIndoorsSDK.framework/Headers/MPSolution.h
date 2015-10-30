//
//  MPSolution.h
//  MapsIndoorSDK for iOS
//
//  Created by Martin Hansen on 7/23/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "MPType.h"

/**
 * Type protocol specification
 */
@protocol MPType
@end
/**
 * The solution model holds data about the buildings and floors in a solution, plus additional meta-data.
 */
@interface MPSolution : JSONModel
/**
 * Solution id
 */
@property NSString* id;
@property NSString* customerId;
@property NSString* name;
@property NSString* defaultLanguage;
@property NSArray* availableLanguages;

/**
 * Array of types in this solution.
 */
@property NSArray<MPType>* types;
/**
 * Get a URL for a given type.
 */
- (NSString*)getTypeUrl:(NSString *)arg;

@end
