//
//  UIColor+HexString.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 06/05/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor (HexString)

+ (UIColor *)colorFromHexString:(NSString *)hexString;

@end
