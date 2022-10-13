//
//  MPLocationDisplayRuleset.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 7/30/13.
//  Copyright (c) 2017 MapsPeople A/S. All rights reserved.
//

#import "MapsIndoors/JSONModel.h"

@class MPLocationDisplayRule;

/**
 This class holds a ruleset that defines how and when to show different location markers.
 */
@interface MPLocationDisplayRuleset : JSONModel

/**
 The base url to the bundle containing the icons for this ruleset. Set the value to your bundle identifier.
 */
@property (nonatomic, strong, nullable) NSString *iconBaseUrl;
/**
 Array of display rules.
 */
@property (nonatomic, strong, nullable) NSMutableArray *displayRules;
/**
 Default display rule
 */
@property (nonatomic, strong, nullable) MPLocationDisplayRule* defaultDisplayRule;

/**
 Add a displayRule to the collection of display rules.
 Prefer using this method instead of accessing the displayRules-array directly.
 
 @param displayRule DisplayRule to add.
 */
- (void) addDisplayRule:(nonnull MPLocationDisplayRule*)displayRule;

/**
Remove a displayRule from the collection of display rules.
Prefer using this method instead of accessing the displayRules-array directly.

@param displayRule DisplayRule to remove.
*/
- (void) removeDisplayRule:(nonnull MPLocationDisplayRule*)displayRule;

/**
 Method for retrieving the first occurence of a rule based on a set of rule names.
 */
- (nullable MPLocationDisplayRule*)getRule:(nullable NSArray*) ruleNames;

/**
 Get the first occurence of a rule based on a rule name.
 */
- (nullable MPLocationDisplayRule*)firstOccur:(nullable NSString*) ruleName;



@end
