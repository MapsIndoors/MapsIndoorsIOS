//
//  MPDataProvider.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 14/07/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^mpDataHandlerBlockType)(NSData* _Nullable data, NSError* _Nullable error, NSHTTPURLResponse* _Nullable response);
typedef void(^mpFileHandlerBlockType)(NSString* _Nullable filePath, NSError* _Nullable error, NSHTTPURLResponse* _Nullable response);


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPDataProvider : NSObject

// Method variants returning NSData:
+ (void) dataWithContentsOfURL:(nonnull NSURL *)url
         ifModifiedSinceAsDate:(NSDate* _Nullable)ifModifiedSinceDate
                         headers:(NSDictionary* _Nullable)headers
             completionHandler:(mpDataHandlerBlockType _Nonnull )handler;

+ (void) dataWithContentsOfURL:(nonnull NSURL *)url
               ifModifiedSince:(NSString* _Nullable)ifModifiedSinceDate
                       headers:(NSDictionary* _Nullable)headers
             completionHandler:(mpDataHandlerBlockType _Nonnull )handler;

+ (void) dataWithContentsOfURL:(nonnull NSURL *)url
               ifModifiedSince:(NSString* _Nullable)ifModifiedSinceDate
                       headers:(NSDictionary* _Nullable)headers
           waitForSessionToken:(BOOL)wait
             completionHandler:(mpDataHandlerBlockType _Nonnull)handler;

// Method variants that returns downloaded content in the given file:
+ (void) downloadContentsOfURL:(nonnull NSURL *)url
                        toFile:(NSString* _Nonnull)filePath
         ifModifiedSinceAsDate:(NSDate* _Nullable)ifModifiedSinceDate
             completionHandler:(mpFileHandlerBlockType _Nonnull)handler;

+ (void) downloadContentsOfURL:(nonnull NSURL *)url
                        toFile:(NSString* _Nonnull)filePath
               ifModifiedSince:(NSString* _Nullable)ifModifiedSinceDate
             completionHandler:(mpFileHandlerBlockType _Nonnull )handler;

+ (void) downloadContentsOfURL:(nonnull NSURL *)url
                        toFile:(NSString* _Nonnull)filePath
               ifModifiedSince:(NSString* _Nullable)ifModifiedSinceDate
           waitForSessionToken:(BOOL)wait
             completionHandler:(mpFileHandlerBlockType _Nonnull)handler;

+ (void) uploadContentsOfFile:(NSString* _Nonnull)filePath
                          toUrl:(nonnull NSURL *)url
             completionHandler:(mpDataHandlerBlockType _Nonnull)handler;

// JSON helpers

+ (void) postJsonObject:(nullable id)jsonThing toURL:(nonnull NSURL*)url headers:(NSDictionary* _Nullable)headers completionHander:(nonnull mpDataHandlerBlockType)completionHandler;
+ (void) deleteJsonObject:(nullable id)jsonThing toURL:(nonnull NSURL*)url headers:(NSDictionary* _Nullable)headers completionHander:(nonnull mpDataHandlerBlockType)completionHandler;
+ (void) putJsonObject:(nullable id)jsonThing toURL:(nonnull NSURL*)url headers:(NSDictionary* _Nullable)headers completionHander:(nonnull mpDataHandlerBlockType)completionHandler;

@end
