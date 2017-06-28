//
//  MPDataField.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 20/10/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPJSONModel.h"

@interface MPDataField : MPJSONModel

@property NSString<Optional>* key;
@property NSString* value;

@end
