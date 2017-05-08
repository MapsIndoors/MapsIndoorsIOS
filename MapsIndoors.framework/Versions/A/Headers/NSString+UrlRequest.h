//
//  NSString+UrlRequest.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 10/02/16.
//  Copyright  Daniel Nielsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(UrlRequest)

+ (nullable NSString*)stringWithContentsOfURL:(nonnull NSURL *)url
                            encoding:(NSStringEncoding)enc
                               error:(NSError * _Nullable * _Nullable)error;

+ (nullable NSString*)stringWithContentsOfURL:(nonnull NSURL *)url
                              ifModifiedSince:(NSDate* _Nullable) ifModifiedSinceDate
                                     encoding:(NSStringEncoding)enc
                                        error:(NSError * _Nullable * _Nullable)error
                                     response:(NSHTTPURLResponse * _Nullable * _Nullable)response;

@end
