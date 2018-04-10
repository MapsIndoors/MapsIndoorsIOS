//
//  MPRouteActionRenderer.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 30/09/15.
//  Copyright © 2015 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MPImageRenderer : NSObject

+ (UIImage *) imageWithView:(UIView *)view;
+ (UIImage *) imageWithSize:(CGSize)size opaque:(BOOL)opaque fromLayer:(CALayer*)layer;     // Usable outside UI Thread
+ (UIImage *) scaledIconFromImage:(UIImage *)image;
+ (UIImage *) imageResize :(UIImage*)img andResizeTo:(CGSize)newSize;


@end
