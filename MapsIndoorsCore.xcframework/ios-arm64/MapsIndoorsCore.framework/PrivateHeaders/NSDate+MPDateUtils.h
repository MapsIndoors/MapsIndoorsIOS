//
//  NSDate+MPDateUtils.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 30/10/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface NSDate (MPDateUtils)

@property (readonly) NSString* _Nullable mp_HTTPDateString;

#pragma mark - UTC ISO8601 converters
- (NSString*) mp_toUtcIso8601;
+ (NSDate*) mp_fromUtcIso8601:(NSString*)s;

@end

NS_ASSUME_NONNULL_END
