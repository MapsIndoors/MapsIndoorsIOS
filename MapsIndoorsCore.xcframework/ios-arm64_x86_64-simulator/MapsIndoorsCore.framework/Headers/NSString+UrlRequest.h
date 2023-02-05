//
//  NSString+UrlRequest.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 10/02/16.
//  Copyright  Daniel Nielsen. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface NSString(UrlRequest)

+ (nullable NSString*)mp_stringWithContentsOfURL:(nonnull NSURL *)url
                            encoding:(NSStringEncoding)enc
                               error:(NSError * _Nullable * _Nullable)error;

+ (nullable NSString*)mp_stringWithContentsOfURL:(nonnull NSURL *)url
                              ifModifiedSince:(NSDate* _Nullable) ifModifiedSinceDate
                                     encoding:(NSStringEncoding)enc
                                        error:(NSError * _Nullable __autoreleasing * _Nullable)error
                                     response:(NSHTTPURLResponse * _Nullable __autoreleasing * _Nullable)response;

@end
