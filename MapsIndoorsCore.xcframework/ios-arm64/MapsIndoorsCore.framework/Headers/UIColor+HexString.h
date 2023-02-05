//
//  UIColor+HexString.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 06/05/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface UIColor (HexString)

+ (nullable UIColor *)colorFromHexString:(nonnull NSString *)hexString;

@end
