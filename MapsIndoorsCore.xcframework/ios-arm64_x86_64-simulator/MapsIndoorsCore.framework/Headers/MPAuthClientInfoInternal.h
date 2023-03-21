//
//  MPAuthClientInfo.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 13/10/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
@import MapsIndoors;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPAuthClientInfoInternal : NSObject<MPAuthClientInfo>
@property (nonatomic, readonly, copy) NSString *clientID;
@property (nonatomic, readonly, copy) NSArray<NSString *> *preferredIDPS;
@end

NS_ASSUME_NONNULL_END
