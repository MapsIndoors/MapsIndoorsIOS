//
//  MPTilePackageUnzipTask.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 24/03/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "MPDataSetCacheTask.h"


NS_ASSUME_NONNULL_BEGIN

@interface MPTilePackageUnzipTask : MPDataSetCacheTask

@property (nonatomic, strong, readonly) NSString*           inputFile;
@property (nonatomic, strong, readonly) NSString*           targetFolder;

+ (instancetype) new NS_UNAVAILABLE;
+ (instancetype) newWithOwner:(id)owner inputFile:(NSString*)inputFile targetFolder:(NSString*)targetFolder;

- (instancetype) init NS_UNAVAILABLE;
- (instancetype) initWithOwner:(id)owner inputFile:(NSString*)inputFile targetFolder:(NSString*)targetFolder;

@end

NS_ASSUME_NONNULL_END
