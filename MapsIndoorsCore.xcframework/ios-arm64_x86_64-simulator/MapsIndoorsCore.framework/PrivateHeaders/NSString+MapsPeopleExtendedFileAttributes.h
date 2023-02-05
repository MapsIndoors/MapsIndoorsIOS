//
//  NSString+MapsPeopleExtendedFileAttributes.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 25/03/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface NSString (MapsPeopleExtendedFileAttributes)

@property (nonatomic, strong, setter=xattr_setLastModified:)    NSString*   xattr_lastModified;
@property (nonatomic, strong, setter=xattr_setDownloadUrl:)     NSString*   xattr_downloadUrl;
@property (nonatomic, strong, setter=xattr_setDownloadDate:)    NSDate*     xattr_downloadDate;
@property (nonatomic, strong, setter=xattr_setContentLanguage:) NSString*   xattr_contentLanguage;
@property (nonatomic, strong, setter=xattr_setCachingScope:)    NSNumber*   xattr_cachingScope;
@property (nonatomic, strong, setter=xattr_setApiEndpoint:)     NSString*   xattr_apiEndpoint;

@end
