//
//  MPAuthClientInfo.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 13/10/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPAuthClientInfo : NSObject
@property (nonatomic, readonly) NSString *clientID;
@property (nonatomic, readonly) NSArray<NSString *> *preferredIDPS;
@end

NS_ASSUME_NONNULL_END
