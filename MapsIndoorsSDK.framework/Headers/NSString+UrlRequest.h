//
//  NSString+UrlRequest.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 10/02/16.
//  Copyright © 2016 Daniel Nielsen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(UrlRequest)

+ (nullable NSString*)stringWithContentsOfURL:(nonnull NSURL *)url
                            encoding:(NSStringEncoding)enc
                               error:(NSError * _Nullable * _Nullable)error;

@end
