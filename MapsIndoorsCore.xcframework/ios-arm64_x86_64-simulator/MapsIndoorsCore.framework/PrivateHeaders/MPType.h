//
//  MPType.h
//  MapsIndoors for iOS
//
//  Created by Martin Hansen on 7/23/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"

@class MPDisplayRule;
@class MPLocationField;
@protocol MPLocationField;

NS_ASSUME_NONNULL_BEGIN

/**
 Location Type model.
 */
@interface MPType : JSONModel

/**
 Get the Display Rule assigned to this Location Type.
 */
@property (nonatomic, strong, nullable) MPDisplayRule* displayRule;
/**
 Dictionary of custom fields
 */
@property (nonatomic, strong, nullable) NSDictionary<NSString*, MPLocationField<MPLocationField>*>* fields;
/**
Location Type name.
*/
@property (nonatomic, strong, nullable) NSString* name;
/**
 Get restrictions for Type. Locations of this Type is restricted to this set of app user roles.
 */
@property (nonatomic, strong, nullable) NSArray<NSString*>* restrictions;
/**
Location Type translated name. May be nil if not defined in the CMS.
*/
@property (nonatomic, strong, nullable) NSString* translatedName;

@end

NS_ASSUME_NONNULL_END
