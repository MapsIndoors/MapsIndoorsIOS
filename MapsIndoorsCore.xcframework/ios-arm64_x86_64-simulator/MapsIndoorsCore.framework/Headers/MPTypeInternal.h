//
//  MPType.h
//  MapsIndoors for iOS
//
//  Created by Martin Hansen on 7/23/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import "JSONModel.h"
@import MapsIndoors;

@class MPDisplayRule;
@protocol MPLocationFieldInternal;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Location Type model.
 */
@interface MPTypeInternal : JSONModel<MPType>

/**
 Get the Display Rule assigned to this Location Type.
 */
@property (nonatomic, strong, nullable) MPDisplayRule* displayRule;
/**
 Dictionary of custom fields
 */
@property (nonatomic, copy, nullable) NSDictionary<NSString*, id<MPLocationField>><MPLocationFieldInternal>* fields;
/**
Location Type name.
*/
@property (nonatomic, copy, nullable) NSString* name;
/**
 Get restrictions for Type. Locations of this Type is restricted to this set of app user roles.
 */
@property (nonatomic, copy, nullable) NSArray<NSString*>* restrictions;
/**
Location Type translated name. May be nil if not defined in the CMS.
*/
@property (nonatomic, copy, nullable) NSString* translatedName;

@end

NS_ASSUME_NONNULL_END
