//
//  HashBuilder.m
//
//  Created by Levi Brown on 12/14/12.
//  See: http://www.mikeash.com/pyblog/friday-qa-2010-06-18-implementing-equality-and-hashing.html
//  Copyright (c) 2012, 2013 Levi Brown <mailto:levigroker@gmail.com>
//  This work is licensed under the Creative Commons Attribution 3.0
//  Unported License. To view a copy of this license, visit
//  http://creativecommons.org/licenses/by/3.0/ or send a letter to Creative
//  Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041,
//  USA.
//
//  The above attribution and the included license must accompany any version
//  of the source code. Visible attribution in any binary distributable
//  including this work (or derivatives) is not required, but would be
//  appreciated.
//

#import "HashBuilder.h"

#define NSUINT_BIT (CHAR_BIT * sizeof(NSUInteger))
#define NSUINTROTATE(val, howmuch) ((((NSUInteger)val) << howmuch) | (((NSUInteger)val) >> (NSUINT_BIT - howmuch)))

@interface HashBuilder ()

@property (nonatomic,assign) NSUInteger contributionCount;
@property (nonatomic,assign) NSUInteger builtHash;

@end

@implementation HashBuilder

#pragma mark - Lifecycle

+ (id)builder
{
    id retVal = [[HashBuilder alloc] init];
    return retVal;
}

#pragma mark - Implementation

- (void)contributeBOOL:(BOOL)flag
{
    [self contributeHash:flag ? 1231 : 1237];
}

- (void)contributeObject:(id)obj
{
    [self contributeHash:[obj hash]];
}

- (void)contributeHash:(NSUInteger)hash
{
    if (hash == 0)
    {
        //Account for nil values as well.
        hash = 31;
    }
    
    if (self.builtHash == 0)
    {
        self.builtHash = hash;
        self.contributionCount = 1;
    }
    else
    {
        self.builtHash = NSUINTROTATE(hash, NSUINT_BIT / ++self.contributionCount) ^ self.builtHash;
    }
}

@end
