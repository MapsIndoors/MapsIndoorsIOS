//
//  NSObject+MPUserInfo.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 11/12/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface NSObject (MPUserInfo)

@property (nonatomic, strong, setter=mp_setUserInfo:) id    mp_userInfo;

@end

NS_ASSUME_NONNULL_END
