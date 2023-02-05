//
//  MPOfflineDataHelper.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 30/11/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPOfflineBundleHelper : NSObject

@property (class, strong, nullable) NSDate* tileDataTimestamp;

+ (nullable NSString*) offlineDataSolutionId;
+ (nullable NSDate*) offlineDataTimestamp;

+ (BOOL) offlineDataHaveDirectionGraphsForSolution:(nonnull NSString*)solutionId;
+ (BOOL) offlineDataHaveMapTilesForSolution:(nonnull NSString*)solutionId;

+ (nullable NSString*) offlinePathForEndpointData:(nonnull NSString*)endPointPath solutionId:(nonnull NSString*)solutionId language:(nullable NSString*) lang;
+ (nullable NSString*) offlinePathForEndpointUrl:(nonnull NSString*)endPointUrl solutionId:(nonnull NSString*)solutionId;

+ (nullable NSDate*) ifModifiedSinceForBundledUrl:(nonnull NSString*)url cachingFile:(nonnull NSString*)targetPath datasetId:(nonnull NSString*)datasetId;

@end
