//
//  MPLocationIndexer.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 29/11/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapsIndoors;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPLocationSourceIndex : NSObject

+ (nullable MPLocationSourceIndex*) current;
+ (MPLocationSourceIndex*) forAPIKey:(NSString*)solutionId;

- (nullable NSMutableDictionary<NSString*, NSNumber*>*) locationIdMap;
- (nullable NSMutableDictionary<NSString*, NSString*>*) readableLocationIdMap;
- (nullable NSMutableDictionary<NSNumber*, id<MPLocation>>*) miLocationIdToMPLocationMap;
- (int) intIdforStringId:(nonnull NSString*)stringId;
- (nullable NSString*) stringIdForIntId:(int)intId;

+ (void) clearAll;
+ (void) clearAllExceptAPIKey:(NSString*)solutionId;

@end

NS_ASSUME_NONNULL_END
