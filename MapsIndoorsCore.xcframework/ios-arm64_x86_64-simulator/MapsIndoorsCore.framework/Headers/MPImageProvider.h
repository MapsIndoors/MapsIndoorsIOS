//
//  MPImageProvider.h
//  MapsIndoorsSDK
//
//  Created by Amine on 28/06/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// > Warning: [INTERNAL - DO NOT USE]
@protocol MPImageProvider<NSObject>

- (void)getImageFromUrlStringAsync: (nonnull NSString*)url imageSize: (CGSize) size completionHandler: (nonnull void (^)(UIImage* _Nullable image, NSError* _Nullable error)) completionHandler;

@end

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPImageProvider : NSObject<MPImageProvider>

- (void)getImageFromUrlStringAsync: (nonnull NSString*)url imageSize: (CGSize) size completionHandler: (nonnull void (^)(UIImage* _Nullable image, NSError* _Nullable error)) completionHandler;
+ (void)getImageFromUrlStringAsync: (nonnull NSString*)url completionHandler: (nonnull void (^)(UIImage* _Nullable image, NSError* _Nullable error)) completionHandler;

@end
