//
//  MPUserRole.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 07/06/2019.
//  Copyright © 2019 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MPUserRole : NSObject

@property (nonatomic, strong, readonly) NSString*       userRoleId;
@property (nonatomic, strong, readonly) NSString*       userRoleName;

+ (instancetype) newFromDict:(NSDictionary*)dict;
- (instancetype) initWithDictionary:(NSDictionary*)dict;
- (instancetype) init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
