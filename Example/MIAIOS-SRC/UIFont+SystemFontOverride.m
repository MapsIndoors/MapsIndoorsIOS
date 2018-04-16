//
//  UIFont+SytemFontOverride.m
//  MIAIOS
//
//  Created by Daniel Nielsen on 11/08/15.
//  Copyright (c) 2015-2018 MapsPeople A/S. All rights reserved.
//

#import "UIFont+SystemFontOverride.h"

@import GoogleFontsiOS;

@implementation UIFont (SystemFontOverride)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

+ (UIFont *)boldSystemFontOfSize:(CGFloat)fontSize {
    return [UIFont robotoBoldFontOfSize:fontSize];
}

+ (UIFont *)systemFontOfSize:(CGFloat)fontSize {
    return [UIFont robotoRegularFontOfSize:fontSize];
}

#pragma clang diagnostic pop

@end
