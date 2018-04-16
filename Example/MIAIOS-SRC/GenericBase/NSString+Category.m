//
//  NSString+Category.m
//  MIAIOS
//
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString(Category)

-(NSString *) stringByStrippingHTML {
    
    NSRange r;
    NSString *s = [self copy];
    s = [s stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
    while ((r = [s rangeOfString:@"<div [^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@"\n"];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    return s;
}

@end
