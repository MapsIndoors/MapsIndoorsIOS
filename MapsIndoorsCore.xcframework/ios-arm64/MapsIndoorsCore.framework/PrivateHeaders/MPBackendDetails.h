#import <Foundation/Foundation.h>
@import MapsIndoors;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Object interfaces

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPBackendDetails : NSObject<MPAuthDetails>
@property (nonatomic, readonly, copy)   NSString *authIssuer;
@property (nonatomic, readonly, copy)   NSString *authScope;
@property (nonatomic, readonly)         BOOL isAuthRequired;
@property (nonatomic, readonly, copy)   NSArray<id<MPAuthClientInfo>> *authClients;
@property (nonatomic, readonly)   NSArray<NSString *> *backendUrls;
@property (nonatomic, readonly)   NSString *sessionToken;
@end


NS_ASSUME_NONNULL_END
