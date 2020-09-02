//
//  MPDataField.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 20/10/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPJSONModel.h"
#import "MPLocationField.h"

@protocol MPDataField
@end

@interface MPDataField : MPJSONModel

@property (nonatomic, strong, nullable) NSString<Optional>* key;
@property (nonatomic, strong, nullable) NSString* value;
/**
 Dictionary of custom fields
 */
@property (nonatomic, strong, nullable, readonly) NSDictionary<NSString*, MPLocationField*><Optional, MPLocationField> *fields;

@end
