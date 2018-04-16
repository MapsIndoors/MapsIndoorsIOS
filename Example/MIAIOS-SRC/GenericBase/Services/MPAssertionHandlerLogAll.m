//
//  MPAssertionHandlerLogAll.m
//  MIAIOS
//
//  Created by Daniel Nielsen on 06/07/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import "MPAssertionHandlerLogAll.h"

@implementation MPAssertionHandlerLogAll

-(void)handleFailureInFunction:(NSString *)functionName file:(NSString *)fileName lineNumber:(NSInteger)line description:(NSString *)format, ...
{
    NSLog(@"[%@] Assertion failure: FUNCTION = (%@) in file = (%@) lineNumber = %li", [self class], functionName, fileName, (long)line );
}

-(void)handleFailureInMethod:(SEL)selector object:(id)object file:(NSString *)fileName lineNumber:(NSInteger)line description:(NSString *)format, ...
{
    NSLog(@"[%@] Assertion failure: METHOD = (%@) for object = (%@) in file = (%@) lineNumber = %li", [self class], NSStringFromSelector(selector), object, fileName, (long)line );
}

@end
