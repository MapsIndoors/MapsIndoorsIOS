//
//  UIColor+Comparison.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 08/03/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import "UIColor+Comparison.h"

#define COLOR_COMP_EPS (0.5/255)
#define cmpComp(a, b) (fabs((a) - (b)) < COLOR_COMP_EPS)

@implementation UIColor (Comparison)

// Credits https://github.com/pixio/UIColor-BetterEquality/blob/master/UIColor%2BBetterEquality.m
- (BOOL)isEqualToColor:(UIColor *)otherColor
{
    const BOOL (^getComponents)(UIColor*, CGFloat*) = ^BOOL(UIColor *color, CGFloat* array) {
        CGColorSpaceModel model = CGColorSpaceGetModel(CGColorGetColorSpace([color CGColor]));
        if (model == kCGColorSpaceModelMonochrome) {
            const CGFloat *oldComponents = CGColorGetComponents(color.CGColor);
            array[0] = array[1] = array[2] = oldComponents[0];
            array[3] = oldComponents[1];
        } else if (model == kCGColorSpaceModelRGB) {
            const CGFloat* oldComponents = CGColorGetComponents(color.CGColor);
            for (int i = 0; i < 4; i++) {
                array[i] = oldComponents[i];
            }
        } else {
            return FALSE;
        }
        return TRUE;
    };
    
    CGFloat myComponents[4];
    BOOL iHaveComponents = getComponents(self, myComponents);
    CGFloat otherComponents[4];
    BOOL theyHaveComponents = getComponents(otherColor, otherComponents);
    
    BOOL equality = iHaveComponents && theyHaveComponents &&
    (   cmpComp(myComponents[0], otherComponents[0])
     && cmpComp(myComponents[1], otherComponents[1])
     && cmpComp(myComponents[2], otherComponents[2]));
    
    //    NSLog(@"Comparing these colors\na:%1.6f, %1.6f, %1.6f\nb:%1.6f, %1.6f, %1.6f\nVerdict:         %@", myComponents[0], myComponents[1], myComponents[2], otherComponents[0], otherComponents[1], otherComponents[2], equality ? @"Equal" : @"Unequal");
    
    return equality;
}

- (BOOL) isWhiteColor {
    
    return [self isEqualToColor:[UIColor whiteColor]];
}

@end
