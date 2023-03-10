//
//  MPVersion.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 11/02/16.
//  Copyright  Daniel Nielsen. All rights reserved.
//

#ifndef MPVersion_h
#define MPVersion_h

#import <Foundation/Foundation.h>

@interface MPSDKVersion : NSObject

+ (nonnull NSString*)versionString;
+ (BOOL)versionWasChanged;

@end

#endif /* MPVersion_h */
