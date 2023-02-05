//
//  MPRouteActionRenderer.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 30/09/15.
//  Copyright © 2015 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPImageRenderer : NSObject

+ (nullable UIImage *) imageWithView:(nonnull UIView *)view;
+ (nullable UIImage *) imageWithSize:(CGSize)size opaque:(BOOL)opaque fromLayer:(nonnull CALayer*)layer;     // Usable outside UI Thread
+ (nullable UIImage *) scaledIconFromImage:(nonnull UIImage *)image;
+ (nullable UIImage *) imageResize:(nonnull UIImage*)img andResizeTo:(CGSize)newSize;

@end
