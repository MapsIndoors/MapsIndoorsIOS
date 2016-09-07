//
//  MPStringCache.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 22/02/16.
//  Copyright © 2016 Daniel Nielsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPStringCache : NSObject

//TEMP
+(void) saveDataFor:(NSString*)key value:(NSString*)value solutionId: (NSString*) solutionId;
+(NSString*) getDataFor:(NSString*)key solutionId: (NSString*) solutionId;


@end
