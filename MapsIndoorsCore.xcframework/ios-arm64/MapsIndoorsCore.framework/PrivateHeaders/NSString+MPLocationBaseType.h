//
//  NSString+MPLocationBaseType.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 21/08/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPLocationBaseType.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface NSString (MPLocationBaseType)

- (MPLocationBaseType)as_MPLocationBaseType;

@end

NS_ASSUME_NONNULL_END
