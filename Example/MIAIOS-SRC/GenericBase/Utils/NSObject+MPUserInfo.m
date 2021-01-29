//
//  NSObject+MPUserInfo.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 11/12/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "NSObject+MPUserInfo.h"
#import <objc/runtime.h>


@implementation NSObject (MPUserInfo)

- (id) mp_userInfo {
    return objc_getAssociatedObject(self, @selector(mp_userInfo));
}

- (void) mp_setUserInfo:(id)userInfo {
    objc_setAssociatedObject(self, @selector(mp_userInfo), userInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
