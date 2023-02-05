#import <Foundation/Foundation.h>
#import "MPAuthDetails.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Object interfaces

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPBackendDetails : NSObject<MPAuthDetails>
@property (nonatomic, readonly)   NSString *authIssuer;
@property (nonatomic, readonly)   NSString *authScope;
@property (nonatomic, readonly)   BOOL isAuthRequired;
@property (nonatomic, readonly)   NSArray<MPAuthClientInfo *> *authClients;
@property (nonatomic, readonly)   NSArray<NSString *> *backendUrls;
@property (nonatomic, readonly)   NSString *sessionToken;
@end


NS_ASSUME_NONNULL_END
