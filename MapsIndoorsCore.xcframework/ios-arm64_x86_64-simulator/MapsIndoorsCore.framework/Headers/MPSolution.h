//
//  MPSolution.h
//  MapsIndoors for iOS
//
//  Created by Martin Hansen on 7/23/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"
#import "MPType.h"

NS_ASSUME_NONNULL_BEGIN

@class MPSolutionConfig;

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 The solution model holds data about the buildings and floors in a solution, plus additional meta-data.
 */
@interface MPSolution : JSONModel

@property (nonatomic, strong, readonly) NSArray<NSString*>*           availableLanguages;
@property (nonatomic, strong, readonly) MPSolutionConfig* config;
@property (nonatomic, strong, nullable, readonly) NSString*   dataSetId;
@property (nonatomic, strong, readonly) NSString*                     defaultLanguage;
@property (nonatomic, strong, nullable, readonly) NSString* mapClientUrl;
@property (nonatomic, strong, readonly) NSArray<NSString*>*           modules;
@property (nonatomic, strong, readonly) NSString*                     name;
@property (nonatomic, strong) NSArray<MPType*>*                       types;

/**
 Optionally contains configuration data for the positioning systems used with the solution.
 The content of the configuration dictionaries are specific for the positioning system.
*/
@property (nonatomic, strong, nullable, readonly) NSDictionary<NSString*, NSDictionary*>* positionProviderConfigs;

/**
 * Get a link for a location in a specific venue, for use with the web-client.
 */
- (nullable NSString*)getMapClientUrlForVenueId:(NSString*)venueId locationId:(NSString*)locationId;

@end

NS_ASSUME_NONNULL_END
