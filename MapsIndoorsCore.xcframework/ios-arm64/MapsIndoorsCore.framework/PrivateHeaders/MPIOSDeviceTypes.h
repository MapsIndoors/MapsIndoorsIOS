//
//  MPIOSDeviceType.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 25/05/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


/*
 *  System Versioning Preprocessor Macros
 */

#define MP_SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define MP_SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define MP_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define MP_SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define MP_SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

/*
 *  Usage:
 *
 *  if (MP_SYSTEM_VERSION_LESS_THAN(@"4.0")) {
 *      ...
 *  }
 *
 *  if (MP_SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"3.1.1")) {
 *      ...
 *  }
 *
 */



typedef enum : NSUInteger {
    MPIOSDeviceScreenType_5_5S_5C_SE,
    MPIOSDeviceScreenType_6_6S_7_7S_8,
    MPIOSDeviceScreenType_PLUS,
    MPIOSDeviceScreenType_X,
    MPIOSDeviceScreenType_Unknown
} MPIOSDeviceScreenType;

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPIOSDeviceTypes : NSObject
+ (MPIOSDeviceScreenType) currentDeviceScreenType;
@end
