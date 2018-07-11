//
//  MPLocationField.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 15/12/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//
#import "MPJSONModel.h"

@protocol MPLocationField

@property NSString* type;
@property NSString* text;
@property NSString* value;

@end

@interface MPLocationField : MPJSONModel

@property NSString* type;
@property NSString* text;
@property NSString<Optional>* value;

@end
