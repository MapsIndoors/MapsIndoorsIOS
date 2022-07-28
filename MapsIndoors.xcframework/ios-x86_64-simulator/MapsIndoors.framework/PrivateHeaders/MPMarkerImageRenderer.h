//
//  MPMarkerImageRenderer.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 30/04/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN


@interface MPMarkerImageRenderer : NSObject

+ (nullable UIImage*)markerImageWithTitle:(NSString*)title image:(UIImage*)image imageSize:(CGSize)imageSize opaque:(BOOL)opaque;
+ (nullable UIImage*)markerImageWithTitle:(NSString*)title image:(UIImage*)image imageSize:(CGSize)imageSize opaque:(BOOL)opaque maxLabelWidth:(NSUInteger)maxLabelWidth;
+ (CGSize)sizeForMarkerImageWithTitle:(NSString*)title image:(UIImage*)image imageSize:(CGSize)imageSize;
+ (CGSize)sizeForMarkerImageWithTitle:(NSString*)title image:(UIImage*)image imageSize:(CGSize)imageSize maxLabelWidth:(NSUInteger)maxLabelWidth;

@end


NS_ASSUME_NONNULL_END
