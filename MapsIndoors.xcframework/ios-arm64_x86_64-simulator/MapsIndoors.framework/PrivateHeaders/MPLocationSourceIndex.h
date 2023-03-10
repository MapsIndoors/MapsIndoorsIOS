//
//  MPLocationIndexer.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 29/11/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MPMutableLocation.h"


NS_ASSUME_NONNULL_BEGIN

@interface MPLocationSourceIndex : NSObject

+ (nullable MPLocationSourceIndex*) current;
+ (MPLocationSourceIndex*) forAPIKey:(NSString*)solutionId;

- (nullable NSMutableDictionary<NSString*, NSNumber*>*) locationIdMap;
- (nullable NSMutableDictionary<NSString*, NSString*>*) readableLocationIdMap;
- (nullable NSMutableDictionary<NSNumber*, MPMutableLocation*>*) miLocationIdToMPLocationMap;
- (int) intIdforStringId:(nonnull NSString*)stringId;
- (nullable NSString*) stringIdForIntId:(int)intId;

+ (void) clearAll;
+ (void) clearAllExceptAPIKey:(NSString*)solutionId;

@end

NS_ASSUME_NONNULL_END
