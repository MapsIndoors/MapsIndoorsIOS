//
//  NSDictionary+MPLocationPropertiesDictionary.h
//  MapsIndoorSDK
//
//  Created by Daniel Nielsen on 21/10/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (MPLocationPropertiesDictionary)
@property (nonatomic, strong) NSNumber* floor;
@property (nonatomic, strong) NSString* venue;
@property (nonatomic, strong) NSString* building;
@property (nonatomic, strong) NSString* roomId;
@property (nonatomic, strong) NSString* type;
@end
