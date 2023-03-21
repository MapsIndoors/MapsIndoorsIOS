//
//  MPSolution+Private.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 28/06/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "MPSolutionInternal.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPSolutionInternal ()

@property (nonatomic, copy, nullable, readwrite) NSArray<NSString*>* availableLanguages;
@property (nonatomic, strong, readwrite) MPSolutionConfig* config;
@property (nonatomic, copy, nullable, readwrite) NSString* defaultLanguage;
@property (nonatomic, copy, nullable, readwrite) NSString* mapClientUrl;
@property (nonatomic, copy, nullable, readwrite) NSArray<NSString*>* modules;
@property (nonatomic, copy, nullable, readwrite) NSString* name;
@property (nonatomic, copy, nullable, readwrite) NSDictionary<NSString*, NSDictionary*>* positionProviderConfigs;
@property (nonatomic, strong, nullable) NSString* solutionId;
@property (nonatomic) BOOL whiteLabel;

@end

NS_ASSUME_NONNULL_END
