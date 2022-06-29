//
//  MPLocationField.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 15/12/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//
@import JSONModel;

#define MPLocationFieldName @"name"
#define MPLocationFieldDescription @"description"
#define MPLocationFieldAlias @"alias"
#define MPLocationFieldPhone @"phone"
#define MPLocationFieldEmail @"email"
#define MPLocationFieldImageUrl @"imageUrl"
#define MPLocationFieldWebsite @"website"


@protocol MPLocationField

@property (nonatomic, strong, nullable) NSString* type;
@property (nonatomic, strong, nullable) NSString* text;
@property (nonatomic, strong, nullable) NSString* value;

@end

@interface MPLocationField : JSONModel

@property (nonatomic, strong, nullable) NSString* type;
@property (nonatomic, strong, nullable) NSString* text;
@property (nonatomic, strong, nullable) NSString<Optional>* value;

@end
