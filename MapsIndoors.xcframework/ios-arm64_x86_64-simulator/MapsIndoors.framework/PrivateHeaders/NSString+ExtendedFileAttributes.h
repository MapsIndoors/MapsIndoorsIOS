//
//  NSString+ExtendedFileAttributes.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 07/03/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (ExtendedFileAttributes)

- (BOOL) xattr_removeAttribute:(nonnull NSString*)attributeName;
- (BOOL) xattr_setValue:(nonnull NSString*)value forAttribute:(nonnull NSString*)attributeName;
- (nullable NSString*) xattr_valueForAttribute:(nonnull NSString *)attributeName;

@end
