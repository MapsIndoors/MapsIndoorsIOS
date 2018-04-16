//
//  MPSimpleFileCache.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 27/03/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPSimpleFileCache : NSObject

@property (nonatomic, strong, readonly) NSString*       name;
@property (nonatomic, strong, readonly) NSString*       path;

+ (instancetype) defaultCache;

- (instancetype) initWithName:(NSString*)name;
- (instancetype) init NS_UNAVAILABLE;

- (NSString*) pathForFileCachingURL:(NSString*)urlString;           // File *may* not exist
- (NSString*) pathForExistingFileCachingURL:(NSString*)urlString;   // File exists if return value is != nil

@end
