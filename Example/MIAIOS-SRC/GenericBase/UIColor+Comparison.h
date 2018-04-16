//
//  UIColor+Comparison.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 08/03/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Comparison)

- (BOOL) isEqualToColor:(UIColor *)otherColor;
- (BOOL) isWhiteColor;

@end
