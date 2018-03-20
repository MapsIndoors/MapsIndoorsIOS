//
//  MPJSONModelHTTPClient.h
//
//  @version 1.4
//  @author Marin Todorov (http://www.underplot.com) and contributors
//

// Copyright (c) 2012-2015 Marin Todorov, Underplot ltd.
// This code is distributed under the terms and conditions of the MIT license.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "MPJSONModel.h"
#import "MPDefines.h"

extern NSString *const kHTTPMethodGET MP_DEPRECATED_ATTRIBUTE;
extern NSString *const kHTTPMethodPOST MP_DEPRECATED_ATTRIBUTE;
extern NSString *const kContentTypeAutomatic MP_DEPRECATED_ATTRIBUTE;
extern NSString *const kContentTypeJSON MP_DEPRECATED_ATTRIBUTE;
extern NSString *const kContentTypeWWWEncoded MP_DEPRECATED_ATTRIBUTE;

typedef void (^JSONObjectBlock)(id json, MPJSONModelError *err) MP_DEPRECATED_ATTRIBUTE;

MP_DEPRECATED_ATTRIBUTE
@interface MPJSONHTTPClient : NSObject

+ (NSMutableDictionary *)requestHeaders MP_DEPRECATED_ATTRIBUTE;
+ (void)setDefaultTextEncoding:(NSStringEncoding)encoding MP_DEPRECATED_ATTRIBUTE;
+ (void)setCachingPolicy:(NSURLRequestCachePolicy)policy MP_DEPRECATED_ATTRIBUTE;
+ (void)setTimeoutInSeconds:(int)seconds MP_DEPRECATED_ATTRIBUTE;
+ (void)setRequestContentType:(NSString *)contentTypeString MP_DEPRECATED_ATTRIBUTE;
+ (void)getJSONFromURLWithString:(NSString *)urlString completion:(JSONObjectBlock)completeBlock MP_DEPRECATED_ATTRIBUTE;
+ (void)getJSONFromURLWithString:(NSString *)urlString params:(NSDictionary *)params completion:(JSONObjectBlock)completeBlock MP_DEPRECATED_ATTRIBUTE;
+ (void)JSONFromURLWithString:(NSString *)urlString method:(NSString *)method params:(NSDictionary *)params orBodyString:(NSString *)bodyString completion:(JSONObjectBlock)completeBlock MP_DEPRECATED_ATTRIBUTE;
+ (void)JSONFromURLWithString:(NSString *)urlString method:(NSString *)method params:(NSDictionary *)params orBodyString:(NSString *)bodyString headers:(NSDictionary *)headers completion:(JSONObjectBlock)completeBlock MP_DEPRECATED_ATTRIBUTE;
+ (void)JSONFromURLWithString:(NSString *)urlString method:(NSString *)method params:(NSDictionary *)params orBodyData:(NSData *)bodyData headers:(NSDictionary *)headers completion:(JSONObjectBlock)completeBlock MP_DEPRECATED_ATTRIBUTE;
+ (void)postJSONFromURLWithString:(NSString *)urlString params:(NSDictionary *)params completion:(JSONObjectBlock)completeBlock MP_DEPRECATED_ATTRIBUTE;
+ (void)postJSONFromURLWithString:(NSString *)urlString bodyString:(NSString *)bodyString completion:(JSONObjectBlock)completeBlock MP_DEPRECATED_ATTRIBUTE;
+ (void)postJSONFromURLWithString:(NSString *)urlString bodyData:(NSData *)bodyData completion:(JSONObjectBlock)completeBlock MP_DEPRECATED_ATTRIBUTE;

@end
