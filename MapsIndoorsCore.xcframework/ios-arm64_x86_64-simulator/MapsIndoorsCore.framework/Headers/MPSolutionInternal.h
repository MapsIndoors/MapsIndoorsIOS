//
//  MPSolution.h
//  MapsIndoors for iOS
//
//  Created by Martin Hansen on 7/23/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"
@import MapsIndoors;

NS_ASSUME_NONNULL_BEGIN

@protocol MPTypeInternal;

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 The solution model holds data about the buildings and floors in a solution, plus additional meta-data.
 */
@interface MPSolutionInternal : JSONModel<MPSolution>

@property (nonatomic, copy, readonly) NSArray<NSString*>*           availableLanguages;
@property (nonatomic, strong, readonly) MPSolutionConfig* config;
@property (nonatomic, copy, nullable, readonly) NSString*   dataSetId;
@property (nonatomic, copy, readonly) NSString*                     defaultLanguage;
@property (nonatomic, copy, nullable, readonly) NSString* mapClientUrl;
@property (nonatomic, copy, readonly) NSArray<NSString*>*           modules;
@property (nonatomic, copy, readonly) NSString*                     name;
@property (nonatomic, copy) NSArray<id<MPType>><MPTypeInternal>* types;

/**
 Optionally contains configuration data for the positioning systems used with the solution.
 The content of the configuration dictionaries are specific for the positioning system.
*/
@property (nonatomic, copy, nullable, readonly) NSDictionary<NSString*, NSDictionary*>* positionProviderConfigs;

/**
 * Get a link for a location in a specific venue, for use with the web-client.
 */
- (nullable NSString*)getMapClientUrlForVenueId:(NSString*)venueId locationId:(NSString*)locationId;

@end

NS_ASSUME_NONNULL_END
