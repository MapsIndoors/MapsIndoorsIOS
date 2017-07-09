//
//  MPImageProvider.h
//  MapsIndoorsSDK
//
//  Created by Amine on 28/06/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MPImageProvider<NSObject>

- (void)getImageFromUrlStringAsync: (NSString*)url imageSize: (CGSize) size completionHandler: (void (^)(UIImage* image, NSError* error)) completionHandler;

@end

@interface MPImageProvider : NSObject<MPImageProvider>

- (void)getImageFromUrlStringAsync: (NSString*)url imageSize: (CGSize) size completionHandler: (void (^)(UIImage* image, NSError* error)) completionHandler;
+ (void)getImageFromUrlStringAsync: (NSString*)url completionHandler: (void (^)(UIImage* image, NSError* error)) completionHandler;

@end
