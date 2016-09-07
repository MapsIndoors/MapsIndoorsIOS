//
//  MPLocationField.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 15/12/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//
#import <JSONModel/JSONModel.h>

@protocol MPLocationField

@property NSString* type;
@property NSString* text;
@property NSString* value;

@end

@interface MPLocationField : JSONModel

@property NSString* type;
@property NSString* text;
@property NSString<Optional>* value;

@end
