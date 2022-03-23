//
//  MPAuthDetails.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 13/10/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MPBackendDetails;
@class MPAuthClientInfo;

NS_ASSUME_NONNULL_BEGIN

@protocol MPAuthDetails <NSObject>

@property (nonatomic, readonly)   NSString *authIssuer;
@property (nonatomic, readonly)   NSString *authScope;
@property (nonatomic, readonly)   BOOL isAuthRequired;
@property (nonatomic, readonly)   NSArray<MPAuthClientInfo *> *authClients;

@end

NS_ASSUME_NONNULL_END
