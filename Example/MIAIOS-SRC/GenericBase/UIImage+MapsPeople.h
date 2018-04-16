//
//  UIImage+MapsPeople.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 02/03/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MapsPeople)

+ (UIImage*) imageWithRepeatingDots:(CGSize)imageSize
                            dotSize:(CGFloat)dotSize
                        dotInterval:(CGFloat)dotInterval
                           dotColor:(UIColor*)dotColor
                      startEndInset:(CGFloat)inset;

+ (UIImage*) imageSolidBar:(CGSize)size
               barFraction:(CGFloat)barFraction
                  barColor:(UIColor*)color;

+ (UIImage*) circleImageForSize:(CGSize)size
                 circleFraction:(CGFloat)circleFraction
                      lineWidth:(CGFloat)lineWidth
                      lineColor:(UIColor*)lineColor
                      fillColor:(UIColor*)fillColor
                    innerCircle:(BOOL)innerCircle;

- (UIImage*) imageWithEmbeddedImage:(UIImage*)innerImage
                 innerImageFraction:(CGFloat)innerImageFraction;

- (UIImage*) imageWithEmbeddedImageNamed:(NSString*)innerImageName
                      innerImageFraction:(CGFloat)innerImageFraction;

@end
