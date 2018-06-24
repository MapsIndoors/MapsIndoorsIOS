//
//  MPLocationField.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 15/12/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//
#import "MPJSONModel.h"

@protocol MPLocationField

@property (nonatomic, strong, nullable) NSString* type;
@property (nonatomic, strong, nullable) NSString* text;
@property (nonatomic, strong, nullable) NSString* value;

@end

@interface MPLocationField : MPJSONModel

@property (nonatomic, strong, nullable) NSString* type;
@property (nonatomic, strong, nullable) NSString* text;
@property (nonatomic, strong, nullable) NSString<Optional>* value;

@end
