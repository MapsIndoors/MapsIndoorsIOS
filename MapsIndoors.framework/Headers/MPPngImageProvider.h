//
//  MPImageProvider.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 04/02/16.
//  Copyright  Daniel Nielsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MPImageProvider.h"

/**
 The image provider acts as a service for fetching images either online or cached offline. Only intended for png images.
 */
@interface MPPngImageProvider : NSObject<MPImageProvider>

/**
 Get an image from a web url
 
 @param url The web url as a string
 @param completionHandler Completion callback handler block that returns either an image or an error (either one will be nil)
 */
- (void) downloadImageFromNetwork : (NSString*)url cplHandler: (void (^)(NSData* image, NSError* error)) completionHandler ;

@end
