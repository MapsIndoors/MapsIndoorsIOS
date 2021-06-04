//
//  MPSolution.h
//  MapsIndoors for iOS
//
//  Created by Martin Hansen on 7/23/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import "MPJSONModel.h"
#import "MPType.h"

/**
 Type protocol specification
 */
@protocol MPType
@end
/**
 The solution model holds data about the buildings and floors in a solution, plus additional meta-data.
 */
@interface MPSolution : MPJSONModel

@property (nonatomic, strong, nullable) NSString* name;
@property (nonatomic, strong, nullable) NSString* defaultLanguage;
@property (nonatomic, strong, nullable) NSArray<NSString*>* availableLanguages;
@property (nonatomic, strong, nullable) NSArray<NSString*>* modules;
@property (nonatomic, strong, nullable) NSString<Optional>* mapClientUrl;

/**
 Array of types in this solution.
 */
@property (nonatomic, strong, nullable) NSArray<MPType*><MPType>* types;

/**
 Get a URL for a given type.
 */
- (nullable NSString*)getTypeUrl:(nonnull NSString *)arg;

/**
 * Get a link for a location in a specific venue, for use with the web-client.
 */
- (nullable NSString*) getMapClientUrlForVenueId:(nonnull NSString*)venueId locationId:(nonnull NSString*)locationId;

@end
