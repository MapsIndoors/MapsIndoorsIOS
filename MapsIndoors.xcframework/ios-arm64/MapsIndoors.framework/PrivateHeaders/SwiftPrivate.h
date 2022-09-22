//
//  SwiftPrivate.h
//  MapsIndoors
//
//  Created by Christian Wolf Johannsen on 28/07/2022.
//  Copyright © 2022 MapsPeople A/S. All rights reserved.
//

#ifndef SwiftPrivate_h
#define SwiftPrivate_h

#import <MapsIndoors/MapsIndoors-Swift.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPDisplayRuleManager ()

@property (nonatomic, weak, class, readonly) MPDisplayRuleManager* sharedInstance;
@property (nonatomic, weak, nullable) MPLocationDisplayRule* defaultDisplayRule;

- (MPLocationDisplayRule*)getDisplayRuleForTypeName:(NSString*)name;
- (MPLocationDisplayRule*)getEffectiveDisplayRuleForLocation:(MPLocation*)location;
- (MPLocationDisplayRule*)resetDisplayRuleForLocation:(MPLocation*)location;
- (MPLocationDisplayRule*)resolveDisplayRuleForLocation:(MPLocation*)location;
- (BOOL)setDisplayRule:(MPLocationDisplayRule*)rule forLocation:(MPLocation*)location;
- (BOOL)setDisplayRule:(MPLocationDisplayRule*)rule forLocationId:(NSString*)name;
- (void)setDisplayRule:(MPLocationDisplayRule*)rule forTypeName:(NSString*)name;

@end

NS_ASSUME_NONNULL_END

#endif /* SwiftPrivate_h */
