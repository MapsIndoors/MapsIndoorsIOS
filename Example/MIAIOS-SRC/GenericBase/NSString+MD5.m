//
//  NSString+MD5.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 27/03/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>

// Credits: http://stackoverflow.com/a/2018626
@implementation NSString (MD5)

- (NSString *)MD5String {
    
    const char *cstr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cstr, (CC_LONG)strlen(cstr), result);
    
    return [NSString stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                                       result[0],  result[1],  result[2],  result[3],
                                       result[4],  result[5],  result[6],  result[7],
                                       result[8],  result[9],  result[10], result[11],
                                       result[12], result[13], result[14], result[15]
                                       ];
}

@end
