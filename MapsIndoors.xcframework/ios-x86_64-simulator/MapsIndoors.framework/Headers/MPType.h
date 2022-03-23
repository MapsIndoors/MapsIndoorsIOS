//
//  MPType.h
//  MapsIndoors for iOS
//
//  Created by Martin Hansen on 7/23/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import "MPJSONModel.h"
#import "MPLocationDisplayRule.h"
#import "MPLocationField.h"


NS_ASSUME_NONNULL_BEGIN

/**
 Location Type model.
 */
@interface MPType : MPJSONModel

/**
Location Type name.
*/
@property (nonatomic, strong, nullable) NSString* name;
/**
Location Type translated name. May be nil if not defined in the CMS.
*/
@property (nonatomic, strong) NSString* translatedName;
/**
Location Type icon.
*/
@property (nonatomic, strong, nullable) NSString* icon DEPRECATED_MSG_ATTRIBUTE("Use MPType.displayRule.iconPath");
/**
Get the Display Rule assigned to this Location Type.
*/
@property (nonatomic, strong, nullable) MPLocationDisplayRule<Optional>* displayRule;
/**
 Dictionary of custom fields
 */
@property (nonatomic, strong, nullable, readonly) NSDictionary<NSString*, MPLocationField*><Optional, MPLocationField> *fields;
/**
Get restrictions for Type. Locations of this Type is restricted to this set of app user roles.
*/
@property (nonatomic, strong, nullable, readonly)  NSArray<NSString*><Optional>*       restrictions;

@end

NS_ASSUME_NONNULL_END
