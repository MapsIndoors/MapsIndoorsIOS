//
//  UIFont+SytemFontOverride.m
//  MapsIndoorsGenericApp
//
//  Created by Daniel Nielsen on 11/08/15.
//  Copyright (c) 2015 MapsPeople A/S. All rights reserved.
//

#import "UIFont+SystemFontOverride.h"
@import GoogleFontsiOS;

@implementation UIFont (SystemFontOverride)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

+ (UIFont *)boldSystemFontOfSize:(CGFloat)fontSize {
    return [UIFont robotoBoldFontOfSize:fontSize];
    //return [UIFont fontWithName:@"Roboto-Bold" size:fontSize];
}

+ (UIFont *)systemFontOfSize:(CGFloat)fontSize {
    return [UIFont robotoRegularFontOfSize:fontSize];
    //return [UIFont fontWithName:@"Roboto-Regular" size:fontSize];
}

#pragma clang diagnostic pop

@end
