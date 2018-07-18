//
//  MPStringCache.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 22/02/16.
//  Copyright  Daniel Nielsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPStringCache : NSObject

//TEMP
+(void) saveDataFor:(nonnull NSString*)key value:(nonnull NSString*)value solutionId: (nonnull NSString*) solutionId;
+(nullable NSString*) getDataFor:(nonnull NSString*)key solutionId: (nonnull NSString*) solutionId;


@end
