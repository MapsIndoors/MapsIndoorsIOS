//
//  MPJSONModelHTTPClient.h
//  MPJSONModel
//

#import "MPJSONModel.h"

extern NSString *const kMPHTTPMethodGET DEPRECATED_ATTRIBUTE;
extern NSString *const kMPHTTPMethodPOST DEPRECATED_ATTRIBUTE;
extern NSString *const kMPContentTypeAutomatic DEPRECATED_ATTRIBUTE;
extern NSString *const kMPContentTypeJSON DEPRECATED_ATTRIBUTE;
extern NSString *const kMPContentTypeWWWEncoded DEPRECATED_ATTRIBUTE;

typedef void (^JSONObjectBlock)(id json, MPJSONModelError *err) DEPRECATED_ATTRIBUTE;

DEPRECATED_ATTRIBUTE
@interface MPJSONHTTPClient : NSObject

+ (NSMutableDictionary *)requestHeaders DEPRECATED_ATTRIBUTE;
+ (void)setDefaultTextEncoding:(NSStringEncoding)encoding DEPRECATED_ATTRIBUTE;
+ (void)setCachingPolicy:(NSURLRequestCachePolicy)policy DEPRECATED_ATTRIBUTE;
+ (void)setTimeoutInSeconds:(int)seconds DEPRECATED_ATTRIBUTE;
+ (void)setRequestContentType:(NSString *)contentTypeString DEPRECATED_ATTRIBUTE;
+ (void)getJSONFromURLWithString:(NSString *)urlString completion:(JSONObjectBlock)completeBlock DEPRECATED_ATTRIBUTE;
+ (void)getJSONFromURLWithString:(NSString *)urlString params:(NSDictionary *)params completion:(JSONObjectBlock)completeBlock DEPRECATED_ATTRIBUTE;
+ (void)JSONFromURLWithString:(NSString *)urlString method:(NSString *)method params:(NSDictionary *)params orBodyString:(NSString *)bodyString completion:(JSONObjectBlock)completeBlock DEPRECATED_ATTRIBUTE;
+ (void)JSONFromURLWithString:(NSString *)urlString method:(NSString *)method params:(NSDictionary *)params orBodyString:(NSString *)bodyString headers:(NSDictionary *)headers completion:(JSONObjectBlock)completeBlock DEPRECATED_ATTRIBUTE;
+ (void)JSONFromURLWithString:(NSString *)urlString method:(NSString *)method params:(NSDictionary *)params orBodyData:(NSData *)bodyData headers:(NSDictionary *)headers completion:(JSONObjectBlock)completeBlock DEPRECATED_ATTRIBUTE;
+ (void)postJSONFromURLWithString:(NSString *)urlString params:(NSDictionary *)params completion:(JSONObjectBlock)completeBlock DEPRECATED_ATTRIBUTE;
+ (void)postJSONFromURLWithString:(NSString *)urlString bodyString:(NSString *)bodyString completion:(JSONObjectBlock)completeBlock DEPRECATED_ATTRIBUTE;
+ (void)postJSONFromURLWithString:(NSString *)urlString bodyData:(NSData *)bodyData completion:(JSONObjectBlock)completeBlock DEPRECATED_ATTRIBUTE;

@end
