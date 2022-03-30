//
//  AppPositionProvider.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 18/11/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AppPositionProvider <NSObject>

@property (nonatomic, strong, readonly          ) NSString*             name;
@property (nonatomic, strong, readonly, nullable) NSString*             version;
@property (nonatomic, strong, readonly, nullable) NSString*             debugInfo;
@property (nonatomic                            ) BOOL                  enableDebugInfo;
@property (nonatomic,         readonly          ) BOOL                  backgroundLocationUpdates;
@property (nonatomic,         readonly          ) BOOL                  canDeliverPosition;

+ (id<MPPositionProvider>) newWithConfigDict:(NSDictionary*)dict;
- (id<MPPositionProvider>) initWithConfigDict:(NSDictionary*)dict;

@end

NS_ASSUME_NONNULL_END
