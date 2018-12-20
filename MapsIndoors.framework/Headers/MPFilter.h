//
//  MPFilter.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 06/11/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPMapExtend.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPFilter : NSObject

@property NSArray<NSString*>* categories;

@property MPMapExtend* bounds;

@property NSArray<NSString*>* parents;

@property NSUInteger take;

@property NSUInteger skip;

@property (nullable) NSNumber* floor;

@end

NS_ASSUME_NONNULL_END
