//
//  MPSolution+Private.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 28/06/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "MPSolution.h"

NS_ASSUME_NONNULL_BEGIN

@class MPType;
@protocol MPType;

@interface MPSolution ()

@property (nonatomic, strong, nullable, readwrite) NSArray<NSString*>* availableLanguages;
@property (nonatomic, strong, readwrite) MPSolutionConfig* config;
@property (nonatomic, strong, nullable, readwrite) NSString* defaultLanguage;
@property (nonatomic, strong, nullable, readwrite) NSString* mapClientUrl;
@property (nonatomic, strong, nullable, readwrite) NSArray<NSString*>* modules;
@property (nonatomic, strong, nullable, readwrite) NSString* name;
@property (nonatomic, strong, nullable, readwrite) NSDictionary<NSString*, NSDictionary*>* positionProviderConfigs;
@property (nonatomic, strong, nullable) NSString* solutionId;
@property (nonatomic, strong, nullable) NSArray<MPType*><MPType>* types;
@property (nonatomic) BOOL whiteLabel;

@end

NS_ASSUME_NONNULL_END
