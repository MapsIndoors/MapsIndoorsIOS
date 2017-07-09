//
//  MPImageProvider.h
//  MapsIndoorsSDK
//
//  Created by Amine on 28/06/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol MPImageProvider <NSObject>

- (void)downloadCacheImage:(NSString*)url;
- (void)getImageFromUrlStringAsync: (NSString*)url imageSize: (CGSize) size completionHandler: (void (^)(UIImage* image, NSError* error)) completionHandler;


@end
