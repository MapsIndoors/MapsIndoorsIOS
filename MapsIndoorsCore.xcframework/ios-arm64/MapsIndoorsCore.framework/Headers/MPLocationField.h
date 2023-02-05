//
//  MPLocationField.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 15/12/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//
#import "JSONModel.h"

#define MPLocationFieldName @"name"
#define MPLocationFieldDescription @"description"
#define MPLocationFieldAlias @"alias"
#define MPLocationFieldPhone @"phone"
#define MPLocationFieldEmail @"email"
#define MPLocationFieldImageUrl @"imageUrl"
#define MPLocationFieldWebsite @"website"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPLocationField : JSONModel

@property (nonatomic, strong, readonly) NSString* type;
@property (nonatomic, strong, readonly) NSString* text;
@property (nonatomic, strong, nullable, readonly) NSString<Optional>* value;

@end

NS_ASSUME_NONNULL_END
