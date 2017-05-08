//
//  MPImageProvider.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 04/02/16.
//  Copyright © 2016 Daniel Nielsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MPImageProvider : NSObject

+ (void) getImageFromUrlStringAsync: (NSString*)url completionHandler: (void (^)(UIImage* image, NSError* error)) completionHandler;

@end
