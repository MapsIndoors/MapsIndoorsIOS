//
//  MPDataSetUrlDownloadTask.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 06/03/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "MPDataSetCacheTask.h"
#import "NSOperation+MapsPeople.h"


@class MPDataSetCacheItem;


NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPDataSetUrlDownloadTask : MPDataSetCacheTask

@property (nonatomic, strong, readonly) NSString*           url;
@property (nonatomic, strong, readonly) NSString*           targetFilePath;
@property (nonatomic, strong, readonly) NSDate*             ifModifiedSince;
@property (nonatomic, strong, readonly) NSNumber*           maxAge;
@property (nonatomic,         readonly) BOOL                didUpdateTargetFile;
@property (nonatomic, strong, readonly) NSHTTPURLResponse*  urlResponse;


+ (instancetype) newWithOwner:(id)owner url:(NSString*)url targetFilePath:(NSString*)targetFilePath ifModifiedSince:(nullable NSDate*)ifModifiedSince maxAge:(nullable NSNumber*)maxAge;
- (instancetype) initWithOwner:(id)owner url:(NSString*)url targetFilePath:(NSString*)targetFilePath ifModifiedSince:(nullable NSDate*)ifModifiedSince maxAge:(nullable NSNumber*)maxAge NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
