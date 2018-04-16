//
//  MPSimpleFileCache.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 27/03/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import "MPSimpleFileCache.h"
#import "NSString+MD5.h"


@implementation MPSimpleFileCache

#pragma mark - init

+ (instancetype) defaultCache {
    
    static MPSimpleFileCache*_sharedCache = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedCache = [[MPSimpleFileCache alloc] initWithName:@"default-cache"];
    });
    
    return _sharedCache;
}

- (instancetype) initWithName:(NSString*)name {
    
    if ( name.length ) {
        
        self = [super init];
        if (self) {
            _name = name;

            NSArray*    paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString*   cachesDirectory = [paths objectAtIndex:0];
            _path = [cachesDirectory stringByAppendingPathComponent:name];
            
            NSError*    error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:_path withIntermediateDirectories:YES attributes:nil error:&error];
            if ( error ) {
                NSLog( @"[E] Error creating cache folder for cache named '%@'", _name );
            }
        }
    }
    
    return self;
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"<MPSimpleFileCache %p: path=%@>", self, self.path];
}


#pragma  mark - Cache interface

- (NSString*) pathForFileCachingURL:(NSString*)urlString {

    return [self.path stringByAppendingPathComponent:[urlString MD5String]];
}

- (NSString*) pathForExistingFileCachingURL:(NSString*)urlString {
    
    NSString*   filePath = [self pathForFileCachingURL:urlString];
    
    return filePath && [[NSFileManager defaultManager] fileExistsAtPath:filePath] ? filePath : nil;
}

@end
