//
//  NSString+ExtendedFileAttributes.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 07/03/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface NSString (ExtendedFileAttributes)

- (BOOL) xattr_removeAttribute:(nonnull NSString*)attributeName;
- (BOOL) xattr_setValue:(nullable NSString*)value forAttribute:(nonnull NSString*)attributeName;
- (nullable NSString*) xattr_valueForAttribute:(nonnull NSString *)attributeName;

@end
