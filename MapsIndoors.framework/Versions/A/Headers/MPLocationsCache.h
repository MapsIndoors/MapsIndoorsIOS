//
//  MPLocationsCache.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 04/02/16.
//  Copyright © 2016 Daniel Nielsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPMapExtend.h"
#import "MPLocation.h"

@interface MPLocationsCache : NSObject

+ (void)setupForSolution: (NSString*)solutionId floor:(NSNumber*)floorLevel language: (NSString*) language readyHandler:(void(^)(void))readyHandler;
+ (void) getCachedLocations:(NSString*)solution mapExtend: (MPMapExtend*)mapExtend floor:(NSNumber*)floor language:(NSString*) language completionHandler:(void (^)(NSArray* locations, NSError* error))completionHandler;


@end
